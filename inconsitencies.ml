let test () =
  let testdir = "_testdir" in
  let testdir2 = "_testdir/inner" in
  Sys.mkdir testdir 0o755 ;
  let wait = Atomic.make true in
  let d1 = Domain.spawn (fun () ->
    while Atomic.get wait do Domain.cpu_relax() done;
    try Sys.rmdir testdir
    with Sys_error e -> assert (e = testdir ^ ": Directory not empty")) in
  let d2 = Domain.spawn (fun () ->
    Atomic.set wait false;
    let made = try Sys.mkdir testdir2 0o755; true
               with Sys_error e -> (
                 assert (e = testdir2 ^ ": No such file or directory") ;
                 false) in
    let exists = Sys.file_exists testdir in
    assert (made = exists)) in
  let () = Domain.join d1 in
  let () = Domain.join d2 in
  ( try Sys.rmdir testdir2
    with Sys_error e -> assert (e = testdir2 ^ ": No such file or directory") ) ;
  ( try Sys.rmdir testdir
    with Sys_error e -> assert (e = testdir ^ ": No such file or directory") ) ;
  ()

let () =
  for i = 0 to 1000000 do
    test ()
  done
