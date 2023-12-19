(* We mix domains and threads. We use the name _node_ for either a
   domain or a thread *)

type worktype = Burn | Tak of int

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
  domain_or:        bool array;
  workload:         worktype array
}

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

let global = Atomic.make 0

let join_one hdls i =
  Semaphore.Binary.acquire hdls.available.(i) ;
  ( match hdls.handles.(i) with
    | NoHdl -> failwith "Semaphore acquired but no handle to join"
    | DomainHdl h -> ( Domain.join h ;
                       hdls.handles.(i) <- NoHdl )
    | ThreadHdl h -> ( Thread.join h ;
                       hdls.handles.(i) <- NoHdl ) )

(** In this first test each spawned domain calls [work] - and then optionally join. *)
(* a simple work item, from ocaml/testsuite/tests/misc/takc.ml *)
let rec tak x y z =
  if x > y then tak (tak (x-1) y z) (tak (y-1) z x) (tak (z-1) x y)
  else z

let rec burn l =
  if List.hd l > 12 then ()
  else
    burn (l @ l |> List.map (fun x -> x + 1))

let work w =
  match w with
  | Burn -> burn [8]
  | Tak i ->
    for _ = 1 to i do
      assert (7 = tak 18 12 6);
    done

let rec spawn_one sj hdls i =
  hdls.handles.(sj.join_permutation.(i)) <-
    if sj.domain_or.(i)
    then DomainHdl (Domain.spawn (run_node sj hdls i))
    else ThreadHdl (Thread.create (run_node sj hdls i) ()) ;
  Semaphore.Binary.release hdls.available.(sj.join_permutation.(i))

and run_node sj hdls i () =
  let sz = Array.length sj.spawn_tree in
  (* spawn nodes *)
  for j = i+1 to sz-1 do
    if sj.spawn_tree.(j) == i
    then spawn_one sj hdls j
  done ;
  Atomic.incr global ;
  work sj.workload.(i) ;
  (* join nodes *)
  let i' = sj.join_permutation.(i) in
  for j = i'+1 to sz-1 do
    if sj.join_tree.(j) == i'
    then join_one hdls j
  done

let run_all_nodes sj =
  Atomic.set global 0 ;
  let sz = Array.length sj.spawn_tree in
  let hdls = { handles = Array.make sz NoHdl;
               available = Array.init sz (fun _ -> Semaphore.Binary.make false) } in
  spawn_one sj hdls 0;
  join_one hdls 0;
  (* all the nodes should have been joined now *)
  Array.for_all (fun h -> h = NoHdl) hdls.handles
   && Atomic.get global = sz

let input = {
  spawn_tree =
  [|-1; 0; 0; 0; 0; 3; 2; 2; 0; 3; 7; 6; 9; 8; 9; 9; 3; 15; 0; 4;
   12; 3; 7; 2; 14; 0; 3; 11; 21; 13; 10; 2; 3; 8; 31; 1; 24; 32; 19; 17;
   8; 15; 7; 7; 23; 8; 45; 9; 22; 23; 0; 38; 5; 16; 11; 12; 16; 0; 17; 3;
   4; 57; 22; 19; 37; 58; 0; 49; 47; 51; 51; 54; 61; 51; 50; 30; 31; 19; 36; 3;
   51; 49; 67; 26; 22; 73; 73; 33; 56; 70; 43; 86; 85; 5; 67|];
  join_permutation =
  [|49; 69; 60; 26; 2; 41; 4; 30; 0; 6; 54; 16; 59; 84; 37; 72; 5; 8; 18; 33;
    66; 45; 86; 15; 93; 81; 1; 7; 70; 58; 39; 11; 92; 83; 91; 55; 77; 68; 12; 38;
    35; 24; 29; 87; 88; 3; 53; 31; 19; 57; 13; 20; 63; 48; 10; 22; 47; 25; 14; 73;
    46; 80; 36; 67; 28; 89; 17; 79; 56; 65; 61; 32; 71; 94; 21; 52; 27; 44; 64; 43;
    23; 34; 42; 85; 90; 50; 76; 9; 75; 51; 78; 82; 74; 40; 62|];
  join_tree =
  [|-1; 0; 1; 2; 2; 4; 1; 4; 0; 0; 7; 9; 5; 1; 6; 0; 6; 9; 5; 3;
    9; 0; 1; 4; 19; 16; 24; 15; 9; 26; 0; 30; 15; 10; 21; 13; 24; 25; 16; 1;
    31; 38; 21; 24; 12; 40; 44; 31; 13; 3; 27; 2; 31; 43; 34; 9; 53; 3; 10; 15;
    24; 19; 44; 25; 1; 17; 55; 0; 28; 39; 55; 44; 0; 42; 25; 38; 11; 31; 49; 7;
    65; 46; 31; 61; 26; 69; 39; 59; 0; 85; 2; 62; 30; 54; 22|];
  domain_or =
  [|false; false; false; true; false; false; false; false; true; true;
    false; false; false; false; true; false; true; false; false; true;
    false; false; false; false; false; false; true; false; true; false;
    false; false; false; false; false; false; false; false; true; false;
    false; false; false; false; true; false; false; false; false; false;
    false; false; true; false; true; false; false; false; false; true;
    false; false; true; false; false; false; false; false; false; false;
    false; false; false; false; false; false; true; false; false; false;
    false; false; false; false; true; true; true; false; false; false;
    true; false; false; false; false|];
  workload =
  [|Tak 163; Burn; Burn; Burn; Tak 128; Tak 93; Burn; Tak 110; Burn; Burn;
    Tak 11; Burn; Tak 9; Burn; Burn; Tak 173; Burn; Tak 136; Tak 186; Burn;
    Tak 88; Burn; Tak 119; Tak 17; Burn; Tak 123; Burn; Burn; Burn; Tak 130;
    Tak 94; Tak 125; Tak 160; Burn; Tak 56; Burn; Burn; Tak 185; Tak 138; Burn;
    Burn; Tak 111; Burn; Tak 117; Tak 78; Tak 116; Burn; Burn; Tak 158; Tak 72;
    Tak 51; Burn; Tak 45; Burn; Tak 27; Tak 153; Tak 55; Tak 167; Tak 37; Tak 191;
    Tak 181; Burn; Tak 167; Burn; Tak 25; Tak 133; Tak 154; Burn; Burn; Burn;
    Burn; Burn; Burn; Burn; Burn; Tak 101; Tak 17; Tak 190; Burn; Burn;
    Burn; Tak 0; Burn; Tak 152; Tak 76; Burn; Burn; Burn; Tak 115; Burn;
    Burn; Burn; Burn; Tak 87; Burn|]; }

let _ =
  for i = 0 to 99999 do
    Printf.printf "%d: %!" i;
    Printf.printf "%b\n" (run_all_nodes input);
  done
