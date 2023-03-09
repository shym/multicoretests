let buf = Buffer.create 16

let tester () =
  Buffer.reset buf;
  Buffer.add_string buf "l;]\184\240\178}\244\222\225\251yG\174";
  let wait = Atomic.make true in
  let dom1 =
    Domain.spawn (fun () ->
        while Atomic.get wait do
          Domain.cpu_relax ()
        done;
        Buffer.clear buf;
        Buffer.clear buf)
  in
  let dom2 =
    Domain.spawn (fun () ->
        Atomic.set wait false;
        Buffer.add_string buf "3\163\015U")
  in
  let obs1 = Domain.join dom1 in
  let obs2 = Domain.join dom2 in
  (obs1, obs2)

let _ =
  for _i = 0 to 1000 do
    tester () |> ignore
  done
