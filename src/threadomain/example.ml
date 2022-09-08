(* { spawn_tree = [|-1; 0; 0|]; join_permutation = [|1; 2; 0|]; *)
(*   join_tree = [|-1; 0; 0|]; domain_or = [|true; false; false|] } *)

type handle =
  | NoHdl
  | DomainHdl of unit Domain.t
  | ThreadHdl of Thread.t

let hdls = Array.make 3 NoHdl
let sems = Array.init 3 (fun _ -> Semaphore.Binary.make false)

let thd1_main () =
  ()

let thd2_main () =
  Semaphore.Binary.acquire sems.(0) ;
  ( match hdls.(0) with
    | DomainHdl h -> Domain.join h
    | _ -> failwith "Unexpected" ) ;
  Semaphore.Binary.acquire sems.(1) ;
  ( match hdls.(0) with
    | ThreadHdl h -> Thread.join h
    | _ -> failwith "Unexpected" )

let dom0_main () =
  hdls.(1) <- ThreadHdl (Thread.create thd1_main ()) ;
  Semaphore.Binary.release sems.(1) ;
  hdls.(2) <- ThreadHdl (Thread.create thd2_main ()) ;
  Semaphore.Binary.release sems.(2)

let _ =
  hdls.(0) <- DomainHdl (Domain.spawn dom0_main) ;
  Semaphore.Binary.release sems.(0) ;
  Semaphore.Binary.acquire sems.(2) ;
  ( match hdls.(2) with
    | ThreadHdl h -> Thread.join h
    | _ -> failwith "Unexpected" )
