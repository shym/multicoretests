open QCheck

(* We mix domains and threads. We use the name _node_ for either a
   domain or a thread *)

(* The global number of nodes that will be spawn *)
let size = 3

let swap arr i j =
  let x = arr.(i) in
  arr.(i) <- arr.(j) ;
  arr.(j) <- x

(* Monadic style; Could be rewritten maybe with Gen.fix? *)
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

(** A test of spawn and join

    [spawn_tree] describes which domain/thread should spawn which other
    domains/threads
    [join_permutation] maps nodes to their position in the [join_tree]
    [join_tree] describes which domain/thread should wait on which
    other domains/threads
    [domain_or] describes whether a given node is a domain (true) or a
    thread (false)

    All those arrays should be of the same length, maybe an array of
    tuples would be a better choice, but make harder to read
*)
type spawn_join = {
  spawn_tree:       int array;
  join_permutation: int array;
  join_tree:        int array;
  domain_or:        bool array
} [@@deriving show { with_path = false }]

let build_spawn_join spawn_tree join_permutation join_tree domain_or =
  { spawn_tree; join_permutation; join_tree; domain_or }

let gen_spawn_join =
  let open Gen in
  build_spawn_join <$> tree <*> permutation <*> tree <*> array_size (pure size) bool

  (* let* st = tree *)
  (* and* jp = permutation *)
  (* and* jt = tree *)
  (* and* dm = array_size (pure size) bool in *)
  (* pure { spawn_tree = st; *)
  (*        join_permutation = jp; *)
  (*        join_tree = jt; *)
  (*        domain_or = dm } *)

type handle =
  | NoHdl
  | DomainHdl of unit Domain.t
  | ThreadHdl of Thread.t

(* All the node handles.
   Since they’ll be used to join, they are stored in join_permutation
   order *)
type handles = {
  handles: handle array;
  available: Semaphore.Binary.t array
}

let join_one hdls i =
  (* Printf.printf "Joining %d\n%!" i ; *)
  Semaphore.Binary.acquire hdls.available.(i) ;
  (* Printf.printf "Semaphore acquired for joining %d\n%!" i ; *)
  ( match hdls.handles.(i) with
    | NoHdl -> failwith "Semaphore acquired but no handle to join"
    | DomainHdl h -> Domain.join h
    | ThreadHdl h -> Thread.join h )
  (* ; Printf.printf "Joined %d\n%!" i *)

let rec spawn_one sj hdls i =
  (* Printf.printf "Spawning %d (aka %d)\n%!" i sj.join_permutation.(i) ; *)
  hdls.handles.(sj.join_permutation.(i)) <-
    if sj.domain_or.(i)
    then DomainHdl (Domain.spawn (run_node sj hdls i))
    else ThreadHdl (Thread.create (run_node sj hdls i) ()) ;
  Semaphore.Binary.release hdls.available.(sj.join_permutation.(i))
  (* ; Printf.printf "Semaphore released for joining %d\n%!" sj.join_permutation.(i) *)

and run_node sj hdls i () =
  (* spawn nodes *)
  for j = i+1 to size-1 do
    if sj.spawn_tree.(j) == i
    then spawn_one sj hdls j
  done ;
  (* join nodes *)
  let i' = sj.join_permutation.(i) in
  for j = i'+1 to size-1 do
    if sj.join_tree.(j) == i'
    then join_one hdls j
  done

let run_all_nodes sj =
  (* Printf.printf "Test %s\n%!" (show_spawn_join sj) ; *)
  let hdls = { handles = Array.make size NoHdl;
               available = Array.init size (fun _ -> Semaphore.Binary.make false) } in
  spawn_one sj hdls 0;
  join_one hdls 0;
  true (* if we reach this safely, the test is passed *)

let main_test = Test.make ~name:"Mash up of threads and domains"
                          ~count:10
                          (make ~print:show_spawn_join gen_spawn_join)
                          (Util.fork_prop_with_timeout 1 run_all_nodes)

let _ =
  Util.set_ci_printing () ;
  QCheck_base_runner.run_tests_main [
    main_test
  ]
