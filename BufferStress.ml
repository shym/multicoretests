let buf = Buffer.create 16

let tester () =
  Buffer.reset buf;
  Buffer.add_string buf "aaaaaaaaaaaaaa";

  let wait = Atomic.make true in
  let dom1 =
    Domain.spawn (fun () ->
        while Atomic.get wait do Domain.cpu_relax () done;
        Buffer.clear buf)
  in
  let dom2 =
    Domain.spawn (fun () ->
        Atomic.set wait false;
        Buffer.add_string buf "aaaa")
  in
  Domain.join dom1;
  Domain.join dom2

let _ =
  for _i = 0 to 10 do
    tester ()
  done
