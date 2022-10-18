open QCheck
include Util

module Var : sig
  type t = int
  val next : unit -> t
  val reset : unit -> unit
  val pp : Format.formatter -> t -> unit
  val show : t -> string
  val shrink : t Shrink.t
end =
struct
  type t = int
  let next, reset =
    let counter = ref 0 in
    (fun () -> let old = !counter in
      incr counter; old),
    (fun () -> counter := 0)
  let show v = Format.sprintf "t%i" v
  let pp fmt v = Format.fprintf fmt "%s" (show v)
  let shrink = Shrink.int
end

module Env : sig
  type t = Var.t list
  val gen_t_var : t -> Var.t Gen.t
  val valid_t_vars : t -> Var.t -> Var.t Iter.t
end =
struct
  type t = Var.t list
  let gen_t_var env = Gen.oneofl env
  let valid_t_vars env v =
    match List.filter (fun v' -> v' <= v) env with
    | v' :: _ when v' = v -> Iter.return v
    | env'                ->
      let a = Array.of_list env' in
      let length = Array.length a in
      Iter.map (fun i -> a.(length - i - 1)) (Shrink.int length)
end

module type CmdSpec = sig
  type t
  (** The type of the system under test *)

  type cmd
  (** The type of commands *)

  val show_cmd : cmd -> string
  (** [show_cmd c] returns a string representing the command [c]. *)

  val gen_cmd : Var.t Gen.t -> (Var.t option * cmd) Gen.t
  (** A command generator.
      It accepts a variable generator and generates a pair [(opt,cmd)] with the option indicating
      an storage index to store the [cmd]'s result. *)

  val shrink_cmd : cmd Shrink.t
  (** A command shrinker.
      To a first approximation you can use [Shrink.nil]. *)

  val fix_cmd : Env.t -> cmd -> cmd Iter.t
  (** A command fixer.
      Fixes the given [cmd] so that it uses only states in the given
      [Env.t]. If the initial [cmd] used a state that is no longer
      available, it should iterate over all the lesser states
      available in [Env.t]. If all the necessary states are still
      available, it should generate a one-element iterator.
      Can assume that [Env.t] is sorted in decreasing order. *)

  type res
  (** The command result type *)

  val show_res : res -> string
  (** [show_res r] returns a string representing the result [r]. *)

  val equal_res : res -> res -> bool

  val init : unit -> t
  (** Initialize the system under test. *)

  val cleanup : t -> unit
  (** Utility function to clean up [t] after each test instance,
      e.g., for closing sockets, files, or resetting global parameters *)

  val run : (Var.t option * cmd) -> t array -> res
  (** [run (opt,c) t] should interpret the command [c] over the various instances of the system under test [t array] (typically side-effecting).
      [opt] indicates the index to store the result. *)
end

(** A functor to create Domain and Thread test setups.
    We use it below, but it can also be used independently *)
module MakeDomThr(Spec : CmdSpec)
  = struct

  (* plain interpreter of a cmd list *)
  let interp_plain sut cs = List.map (fun c -> (c, Spec.run c sut)) cs

  (* val gen_cmds : Env.t -> int -> (Env.t * (Var.t option * Spec.cmd) list) Gen.t *)
  let rec gen_cmds env fuel =
    Gen.(if fuel = 0
         then return (env,[])
         else
           Spec.gen_cmd (Env.gen_t_var env) >>= fun (opt,c) ->
             let env = match opt with None -> env | Some v -> v::env in
             gen_cmds env (fuel-1) >>= fun (env,cs) -> return (env,(opt,c)::cs))
  (** A fueled command list generator.
      Accepts an environment parameter [env] to enable [cmd] generation of multiple [t]s
      and returns the extended environment. *)

  let gen_cmds_size env size_gen = Gen.sized_size size_gen (gen_cmds env)

  let shrink_cmd (opt,c) = Iter.map (fun c -> opt,c) (Spec.shrink_cmd c)

  (* Note: the [env] fed to [Spec.fix_cmd] are in reverse (ie should
     be _decreasing_) order *)
  let fix_cmds env cmds =
    let rec aux env cmds =
      match cmds with
      | [] -> Iter.return []
      | (opt,cmd) :: cmds ->
          let env' = Option.fold ~none:env ~some:(fun i -> i::env) opt in
          Iter.map2 (fun cmd cmds -> (opt,cmd)::cmds) (Spec.fix_cmd env cmd) (aux env' cmds)
    in aux env cmds

  (* Note that the result is built in reverse (ie should be
     _decreasing_) order *)
  let rec extract_env env cmds =
    match cmds with
    | []                  -> env
    | (Some i, _) :: cmds -> extract_env (i::env) cmds
    | (None,   _) :: cmds -> extract_env     env  cmds

  let shrink_triple' (seq,p1,p2) =
    let open Iter in
    (* Shrinking heuristic:
       First reduce the cmd list sizes as much as possible, since the interleaving
       is most costly over long cmd lists. *)
    let concat_map f it = flatten (map f it) in
    let fix_seq seq =
      let seq_env = extract_env [0] seq in
      let triple seq p1 p2 = (seq,p1,p2) in
      map triple (fix_cmds [0] seq) <*> fix_cmds seq_env p1 <*> fix_cmds seq_env p2
    in
    let seq_env = extract_env [0] seq in

    concat_map fix_seq (Shrink.list_spine seq)
    <+>
    (match p1 with [] -> Iter.empty | c1::c1s -> Iter.return (seq@[c1],c1s,p2))
    <+>
    (match p2 with [] -> Iter.empty | c2::c2s -> Iter.return (seq@[c2],p1,c2s))
    <+>
    concat_map (fun p1 -> Iter.map (fun p1 -> (seq,p1,p2)) (fix_cmds seq_env p1)) (Shrink.list_spine p1)
    <+>
    concat_map (fun p2 -> Iter.map (fun p2 -> (seq,p1,p2)) (fix_cmds seq_env p2)) (Shrink.list_spine p2)
    <+>
    (* Secondly reduce the cmd data of individual list elements *)
    (map (fun seq' -> (seq',p1,p2)) (Shrink.list_elems shrink_cmd seq))
    <+>
    (map (fun p1' -> (seq,p1',p2)) (Shrink.list_elems shrink_cmd p1))
    <+>
    (map (fun p2' -> (seq,p1,p2')) (Shrink.list_elems shrink_cmd p2))

  let shrink_triple (size,t) =
    Iter.map (fun t -> (size,t)) (shrink_triple' t)

  let show_cmd (opt,c) = match opt with
    | None   -> Spec.show_cmd c
    | Some v -> Printf.sprintf "let %s = %s" (Var.show v) (Spec.show_cmd c)

  let init_cmd = "let t0 = init ()"
  let init_cmd_ret = init_cmd ^ "  : ()"

  let arb_cmds_par seq_len par_len =
    let gen_triple st =
      Var.reset ();
      let init_var = Var.next () in
      assert (init_var = 0);
      Gen.(int_range 2 (2*par_len) >>= fun dbl_plen ->
           let par_len1 = dbl_plen/2 in
           gen_cmds_size [init_var] (int_bound seq_len) >>= fun (env,seq_pref) ->
           gen_cmds_size env (return par_len1) >>= fun (_env1,par1) ->
           gen_cmds_size env (return (dbl_plen - par_len1)) >>= fun (_env2,par2) ->
           let array_size = Var.next () in
           return (array_size,(seq_pref,par1,par2))) st
    in
    make ~print:(fun (_,t) -> print_triple_vertical ~init_cmd show_cmd t) ~shrink:shrink_triple gen_triple

  let init_sut array_size =
    let sut = Spec.init () in
    Array.make array_size sut

  let cleanup sut seq_pref cmds1 cmds2 =
    let cleanup_opt ((opt,_c),_res) = match opt with
      | None -> ()
      | Some v -> Spec.cleanup sut.(v) in
    Spec.cleanup sut.(0); (* always present *)
    List.iter cleanup_opt seq_pref;
    List.iter cleanup_opt cmds1;
    List.iter cleanup_opt cmds2

  let rec check_seq_cons array_size pref cs1 cs2 seq_sut seq_trace = match pref with
    | (c,res)::pref' ->
        if Spec.equal_res res (Spec.run c seq_sut)
        then check_seq_cons array_size pref' cs1 cs2 seq_sut (c::seq_trace)
        else (cleanup seq_sut pref cs1 cs2; false)
    (* Invariant: call Spec.cleanup immediately after mismatch  *)
    | [] -> match cs1,cs2 with
            | [],[] -> cleanup seq_sut pref cs1 cs2; true
            | [],(c2,res2)::cs2' ->
                if Spec.equal_res res2 (Spec.run c2 seq_sut)
                then check_seq_cons array_size pref cs1 cs2' seq_sut (c2::seq_trace)
                else (cleanup seq_sut pref cs1 cs2; false)
            | (c1,res1)::cs1',[] ->
                if Spec.equal_res res1 (Spec.run c1 seq_sut)
                then check_seq_cons array_size pref cs1' cs2 seq_sut (c1::seq_trace)
                else (cleanup seq_sut pref cs1 cs2; false)
            | (c1,res1)::cs1',(c2,res2)::cs2' ->
                (if Spec.equal_res res1 (Spec.run c1 seq_sut)
                 then check_seq_cons array_size pref cs1' cs2 seq_sut (c1::seq_trace)
                 else (cleanup seq_sut pref cs1 cs2; false))
                ||
                (* rerun to get seq_sut to same cmd branching point *)
                (let seq_sut' = init_sut array_size in
                 let _ = interp_plain seq_sut' (List.rev seq_trace) in
                 if Spec.equal_res res2 (Spec.run c2 seq_sut')
                 then check_seq_cons array_size pref cs1 cs2' seq_sut' (c2::seq_trace)
                 else (cleanup seq_sut' pref cs1 cs2; false))
end

(** A functor to create all three (Domain, Thread, and Effect) test setups.
    The result [include]s the output module from the [MakeDomThr] functor above *)
module Make(Spec : CmdSpec)
= struct

  module FirstTwo = MakeDomThr(Spec)
  include FirstTwo

  (* Linearizability test based on [Domain], [Thread], or [Effect] *)
  let lin_test ~count ~name (lib : [ `Domain | `Thread | `Effect ]) =
    let seq_len,par_len = 20,12 in
    match lib with

  (* Negative linearizability test based on [Domain], [Thread], or [Effect] *)
  let neg_lin_test ~count ~name (lib : [ `Domain | `Thread | `Effect ]) =
    let seq_len,par_len = 20,12 in
    match lib with
end
