(* type handle = *)
(*   | NoHdl *)
(*   | DomainHdl of unit Domain.t *)
(*   | ThreadHdl of Thread.t *)

(* let hdls = Array.make 2 NoHdl *)
(* let sems = Array.init 2 (fun _ -> Semaphore.Binary.make false) *)

(* let thd1_main () = *)
(*   Semaphore.Binary.acquire sems.(0) ; *)
(*   ( match hdls.(0) with *)
(*     | DomainHdl h -> Domain.join h *)
(*     | _ -> failwith "Unexpected" ) *)

(* let dom0_main () = *)
(*   hdls.(1) <- ThreadHdl (Thread.create thd1_main ()) ; *)
(*   Semaphore.Binary.release sems.(1) *)

(* let _ = *)
(*   hdls.(0) <- DomainHdl (Domain.spawn dom0_main) ; *)
(*   Semaphore.Binary.release sems.(0) ; *)
(*   Semaphore.Binary.acquire sems.(1) ; *)
(*   ( match hdls.(1) with *)
(*     | ThreadHdl h -> Thread.join h *)
(*     | _ -> failwith "Unexpected" ) *)


let hdl = ref (None : unit Domain.t option)
let hdl_set = (* to wait until [hdl] has been set *)
  Semaphore.Binary.make false
let dom_joined = Semaphore.Binary.make false

let dom_main () =
  Semaphore.Binary.acquire hdl_set ;
  match !hdl with
  | Some h -> ( Domain.join h ;
                Printf.printf "Domain alive or terminated?\n%!" ;
                Semaphore.Binary.release dom_joined )
  | _ -> failwith "Should never happen"

let _ =
  hdl := Some (Domain.spawn dom_main) ;
  Semaphore.Binary.release hdl_set ;
  Semaphore.Binary.acquire dom_joined

(* let _ = print_int Domain.recommended_domain_count *)
