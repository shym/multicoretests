open Lin_base

module Make_internal (ExpandedSpec : Lin_internal.ExpandedSpec) = struct
  module M = Lin_internal.Make(ExpandedSpec)
  include M

  (* operate over arrays to avoid needless allocation underway *)
  let interp sut cs =
    let cs_arr = Array.of_list cs in
    let res_arr = Array.map (fun c -> Domain.cpu_relax(); ExpandedSpec.run c sut) cs_arr in
    List.combine cs (Array.to_list res_arr)

  (* Linearizability property based on [Domain] and an Atomic flag *)
  let lin_prop_domain (array_size, (seq_pref,cmds1,cmds2)) =
    let sut = init_sut array_size in
    let pref_obs = interp sut seq_pref in
    let wait = Atomic.make true in
    let dom1 = Domain.spawn (fun () -> while Atomic.get wait do Domain.cpu_relax() done; try Ok (interp sut cmds1) with exn -> Error exn) in
    let dom2 = Domain.spawn (fun () -> Atomic.set wait false; try Ok (interp sut cmds2) with exn -> Error exn) in
    let obs1 = Domain.join dom1 in
    let obs2 = Domain.join dom2 in
    let obs1 = match obs1 with Ok v -> v | Error exn -> raise exn in
    let obs2 = match obs2 with Ok v -> v | Error exn -> raise exn in
    cleanup sut pref_obs obs1 obs2;
    let seq_sut = init_sut array_size in
    check_seq_cons array_size pref_obs obs1 obs2 seq_sut []
      || QCheck.Test.fail_reportf "  Results incompatible with sequential execution\n\n%s"
         @@ Util.print_triple_vertical ~fig_indent:5 ~res_width:35 ~init_cmd:init_cmd_ret
              (fun (c,r) -> Printf.sprintf "%s : %s" (show_cmd c) (ExpandedSpec.show_res r))
              (pref_obs,obs1,obs2)

  let lin_test ~count ~name =
    lin_test ~rep_count:50 ~count ~retries:3 ~name ~lin_prop:lin_prop_domain

  let neg_lin_test ~count ~name =
    neg_lin_test ~rep_count:50 ~count ~retries:3 ~name ~lin_prop:lin_prop_domain
end

module Make (Spec : Lin_common.Spec) = Make_internal(Lin_common.ExpandSpec(Spec))
