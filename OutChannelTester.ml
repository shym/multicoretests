module Out_channel = struct
  include Out_channel

  let seek ch v = seek ch (Int64.of_int v)
end

let log =
  List.map
    (fun (tk0, tk1, tk2) ->
      (Array.of_list tk0, Array.of_list tk1, Array.of_list tk2))
    [
      (* insert log here *)
    ]

let tester (tk0, tk1, tk2) =
  let path, t = Filename.open_temp_file "out-channel-" "" in
  let run thunk = try thunk t with _ -> () in

  Array.iter run tk0;

  let wait = Atomic.make true in
  let dom1 =
    Domain.spawn (fun () ->
        while Atomic.get wait do
          Domain.cpu_relax ()
        done;
        Array.iter run tk1)
  in

  let dom2 =
    Domain.spawn (fun () ->
        Atomic.set wait false;
        Array.iter run tk2)
  in

  let _ = Domain.join dom1 in
  let _ = Domain.join dom2 in

  Out_channel.close t;
  Sys.remove path

let _ =
  for i = 1 to 100000 do
    List.iter tester log;
    Printf.printf "%d\n%!" i
  done
