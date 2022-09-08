(* { spawn_tree = [|-1; 0; 0|]; join_permutation = [|1; 2; 0|]; *)
(*   join_tree = [|-1; 0; 0|]; domain_or = [|true; false; false|] } *)

type handle =
  | NoHdl
  | DomainHdl of unit Domain.t
  | ThreadHdl of Thread.t

let hdls = Array.make 2 NoHdl
let sems = Array.init 2 (fun _ -> Semaphore.Binary.make false)

let thd1_main () =
  Semaphore.Binary.acquire sems.(0) ;
  ( match hdls.(0) with
    | DomainHdl h -> Domain.join h
    | _ -> failwith "Unexpected" )

let dom0_main () =
  hdls.(1) <- ThreadHdl (Thread.create thd1_main ()) ;
  Semaphore.Binary.release sems.(1)

let _ =
  hdls.(0) <- DomainHdl (Domain.spawn dom0_main) ;
  Semaphore.Binary.release sems.(0) ;
  Semaphore.Binary.acquire sems.(1) ;
  ( match hdls.(1) with
    | ThreadHdl h -> Thread.join h
    | _ -> failwith "Unexpected" )


(* Even though the following does work: *)

(*

let hdl = ref (None : unit Domain.t option)
let sem = Semaphore.Binary.make false

let _ =
  hdl := Some (Domain.spawn (fun () -> Semaphore.Binary.acquire sem ;
                                       match !hdl with
                                       | Some h -> Domain.join h
                                       | _ -> failwith "boom")) ;
  Semaphore.Binary.release sem

*)

(* let _ = print_int Domain.recommended_domain_count *)
