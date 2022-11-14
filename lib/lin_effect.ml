(** Definitions for Effect interpretation *)

(* Scheduler adapted from https://kcsrk.info/slides/retro_effects_simcorp.pdf *)
open Effect
open Effect.Deep

type _ t += Fork : (unit -> unit) -> unit t
         | Yield : unit t

let enqueue k q = Queue.push k q
let dequeue q =
  if Queue.is_empty q
  then () (*Finished*)
  else continue (Queue.pop q) ()

let start_sched main =
  (* scheduler's queue of continuations *)
  let q = Queue.create () in
  let rec spawn = fun (type res) (f : unit -> res) ->
    match_with f ()
      { retc = (fun _v -> dequeue q); (* value case *)
        exnc = (fun e -> print_string (Printexc.to_string e); raise e);
        effc = (fun (type a) (e : a t) -> match e with
            | Yield  -> Some (fun (k : (a, _) continuation) -> enqueue k q; dequeue q)
            | Fork f -> Some (fun (k : (a, _) continuation) -> enqueue k q; spawn f)
            | _      -> None ) }
  in
  spawn main

(* short hands *)
let fork f = perform (Fork f)
let yield () = perform Yield



  (** A refined [CmdSpec] specification with generator-controlled [Yield] effects *)
  module EffSpec
  = struct

    type t = Spec.t
    let init = Spec.init
    let cleanup = Spec.cleanup

    type cmd = SchedYield | UserCmd of Spec.cmd [@@deriving qcheck]

    let show_cmd c = match c with
      | SchedYield -> "<SchedYield>"
      | UserCmd c  -> Spec.show_cmd c

    let gen_cmd =
      (Gen.frequency
         [(3,Gen.return SchedYield);
          (5,Gen.map (fun c -> UserCmd c) Spec.gen_cmd)])

    let shrink_cmd c = match c with
      | SchedYield -> Iter.empty
      | UserCmd c -> Iter.map (fun c' -> UserCmd c') (Spec.shrink_cmd c)

    type res = SchedYieldRes | UserRes of Spec.res

    let show_res r = match r with
      | SchedYieldRes -> "<SchedYieldRes>"
      | UserRes r     -> Spec.show_res r

    let equal_res r r' = match r,r' with
      | SchedYieldRes, SchedYieldRes -> true
      | UserRes r, UserRes r' -> Spec.equal_res r r'
      | _, _ -> false

    let run c sut = match c with
      | SchedYield ->
          (yield (); SchedYieldRes)
      | UserCmd uc ->
          let res = Spec.run uc sut in
          UserRes res
  end

  module EffTest = MakeDomThr(EffSpec)

  let filter_res rs = List.filter (fun (c,_) -> c <> EffSpec.SchedYield) rs

  (* Parallel agreement property based on effect-handler scheduler *)
  let lin_prop_effect =
    (fun (seq_pref,cmds1,cmds2) ->
       let sut = Spec.init () in
       (* exclude [Yield]s from sequential prefix *)
       let pref_obs = EffTest.interp_plain sut (List.filter (fun c -> c <> EffSpec.SchedYield) seq_pref) in
       let obs1,obs2 = ref [], ref [] in
       let main () =
         (* For now, we reuse [interp_thread] which performs useless [Thread.yield] on single-domain/fibered program *)
         fork (fun () -> let tmp1 = EffTest.interp_thread sut cmds1 in obs1 := tmp1);
         fork (fun () -> let tmp2 = EffTest.interp_thread sut cmds2 in obs2 := tmp2); in
       let () = start_sched main in
       let () = Spec.cleanup sut in
       let seq_sut = Spec.init () in
       (* exclude [Yield]s from sequential executions when searching for an interleaving *)
       EffTest.check_seq_cons (filter_res pref_obs) (filter_res !obs1) (filter_res !obs2) seq_sut []
       || Test.fail_reportf "  Results incompatible with linearized model\n\n%s"
       @@ Util.print_triple_vertical ~fig_indent:5 ~res_width:35
         (fun (c,r) -> Printf.sprintf "%s : %s" (EffSpec.show_cmd c) (EffSpec.show_res r))
         (pref_obs,!obs1,!obs2))

    | `Effect ->
        (* this generator is over [EffSpec.cmd] including [SchedYield], not [Spec.cmd] like the above two *)
        let arb_cmd_triple = EffTest.arb_cmds_par seq_len par_len in
        let rep_count = 1 in
        Test.make ~count ~retries:10 ~name
          arb_cmd_triple (repeat rep_count lin_prop_effect)

    | `Effect ->
        (* this generator is over [EffSpec.cmd] including [SchedYield], not [Spec.cmd] like the above two *)
        let arb_cmd_triple = EffTest.arb_cmds_par seq_len par_len in
        let rep_count = 1 in
        Test.make_neg ~count ~retries:10 ~name
          arb_cmd_triple (repeat rep_count lin_prop_effect)
