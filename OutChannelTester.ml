let i1 f x = try f x |> ignore with _ -> ()
let i2 f w x = i1 (f w) x
let i3 f v w x = i1 (f v w) x
let i4 f u v w x = i1 (f u v w) x

let tester () =
  let path, t = Filename.open_temp_file "out-channel-" "" in

  i1 Out_channel.close t;

  let wait = Atomic.make true in
  let dom1 =
    Domain.spawn (fun () ->
        while Atomic.get wait do
          Domain.cpu_relax ()
        done;

        i1 Out_channel.pos t;
        i4 Out_channel.output_substring t
          "\1707NW\000'an\191\015\145\n\
          \ \
           \236C\250\027\200\185\149\153q\"\179!5B_Q\173\028\243j6yn\129\2209\003<\168\156d)\169\247\212\199Q\031-\152"
          0 4;
        i1 Out_channel.close_noerr t;
        i2 Out_channel.output_char t '\021';
        i1 Out_channel.is_buffered t;
        i2 Out_channel.output_byte t 2;
        i2 Out_channel.seek t 83L;
        i2 Out_channel.set_buffered t false)
  in

  let dom2 =
    Domain.spawn (fun () ->
        Atomic.set wait false;
        i2 Out_channel.set_binary_mode t false;
        i2 Out_channel.output_char t '=';
        i4 Out_channel.output_substring t "\153\002\213\144\240" 0 39;
        i1 Out_channel.flush t;
        i2 Out_channel.set_buffered t false;
        i1 Out_channel.pos t;
        i2 Out_channel.set_buffered t true;
        i2 Out_channel.output_char t '\132')
  in

  let _ = Domain.join dom1 in
  let _ = Domain.join dom2 in

  Out_channel.close t;
  Sys.remove path

let _ =
  for i = 0 to 1000 do
    for _j = 0 to 1000 do
      tester () |> ignore
    done;
    Printf.printf "%d\n%!" (i + 1)
  done
