let rec tree path =
  if Sys.file_exists path then (
    Format.printf "%s\n" path;
    if Sys.is_directory path then
      Array.iter
        (fun name -> tree (Filename.concat path name))
        (Sys.readdir path))

let test () =
  let testdir = "_testdir" in
  let testdir2 = "_testdir/inner" in

  Sys.mkdir testdir 0o755;

  let wait = Atomic.make true in
  let d1 =
    Domain.spawn (fun () ->
        while Atomic.get wait do
          Domain.cpu_relax ()
        done;
        try Sys.rmdir testdir
        with Sys_error e -> assert (e = testdir ^ ": Directory not empty"))
  in

  let d2 =
    Domain.spawn (fun () ->
        Atomic.set wait false;
        let made =
          try
            Sys.mkdir testdir2 0o755;
            true
          with Sys_error e ->
            assert (e = testdir2 ^ ": No such file or directory");
            false
        in
        let exists = Sys.file_exists testdir in
        made = exists)
  in

  let () = Domain.join d1 in
  let consistent = Domain.join d2 in
  if not consistent then (
    Format.printf "Inconsistency found!\n";
    tree testdir;
    Format.print_flush ());
  (try Sys.rmdir testdir2
   with Sys_error e -> assert (e = testdir2 ^ ": No such file or directory"));
  (try Sys.rmdir testdir
   with Sys_error e -> assert (e = testdir ^ ": No such file or directory"));
  ()

let () =
  for i = 0 to 1000000 do
    if i mod 10000 = 0 then Printf.printf "Run %d\n%!" i;
    test ()
  done
