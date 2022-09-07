open QCheck

(* The global number of Domains and Threads that will be spawn *)
let size = 16

let swap arr i j =
  let x = arr.(i) in
  arr.(i) <- arr.(j) ;
  arr.(j) <- x

(* Monadic style *)
(* let permutation = *)
(*   let open Gen in *)
(*   let rec aux arr i = *)
(*     if i == 0 *)
(*     then pure arr *)
(*     else let* j = int_bound i in *)
(*          let* _ = fun _ -> swap arr i j in *)
(*          aux arr (i-1) *)
(*   in *)
(*   let* arr = fun _ -> Array.init size (fun x -> x) in *)
(*   aux arr (size-1) *)

(** Generate a permutation of [0..size-1] *)
let permutation s =
  let arr = Array.init size (fun x -> x) in
  for i = size - 1 downto 1 do
    swap arr i (Gen.int_bound i s)
  done ;
  arr

(** Generate a tree of size nodes
 The tree is represented as an array [a] of integers, [a.(i)] being
 the parent of node [i]. Node [0] is the root of the tree.
 *)
let tree s =
  let parent i =
    if i == 0
    then -1
    else Gen.int_bound (i-1) s
  in
  Array.init size parent

let _ =
  Gen.generate1 permutation |> Array.iter (Printf.printf "%d ") ;
  Printf.printf "\n" ;
  Gen.generate1 tree |> Array.iter (Printf.printf "%d ") ;
  Printf.printf "\n"
