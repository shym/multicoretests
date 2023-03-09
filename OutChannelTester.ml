let i1 f x = try f x |> ignore with _ -> ()
let i2 f w x = i1 (f w) x
let i3 f v w x = i1 (f v w) x
let i4 f u v w x = i1 (f u v w) x

let tester () =
  let path, t = Filename.open_temp_file "out-channel-" "" in

  i2 Out_channel.output_byte t 74;
  i1 Out_channel.flush_all ();
  i1 Out_channel.flush_all ();
  i4 Out_channel.output_substring t "\030" 3 3;
  i1 Out_channel.flush_all ();
  i2 Out_channel.set_binary_mode t false;
  i2 Out_channel.output_char t '\178';
  i2 Out_channel.output_string t "\165Q\195J\152\228\230";
  i1 Out_channel.pos t;

  let wait = Atomic.make true in
  let dom1 =
    Domain.spawn (fun () ->
        while Atomic.get wait do
          Domain.cpu_relax ()
        done;

        i2 Out_channel.set_binary_mode t false;
        i2 Out_channel.output_string t "\031}";
        i4 Out_channel.output_substring t
          "\005s\158\014\166\202\\I\221up\145\222\219sa18d\028\019\127\198\230{j#J+\019u\1690P \
           m\150\225\230F\184z\243\165\191!cG\206g\137\132v\143\176d(\214P\149\194\181\001\150\212\\c\027M\028u)"
          5 3;
        i2 Out_channel.output_byte t 3;
        i2 Out_channel.output_byte t 85;
        i4 Out_channel.output_substring t "\206\145\227\210Y>\230\195" 1 30;
        i2 Out_channel.set_binary_mode t false;
        i1 Out_channel.flush_all ();
        i2 Out_channel.output_string t "1I-u\184\192\"\207\159";
        i2 Out_channel.output_byte t 8;
        i1 Out_channel.close_noerr t;
        i1 Out_channel.close_noerr t)
  in

  let dom2 =
    Domain.spawn (fun () ->
        Atomic.set wait false;
        i2 Out_channel.set_buffered t false;
        i2 Out_channel.output_char t '`';
        i4 Out_channel.output_substring t
          "\157\159/I\178\030\182g\144c\0048\0284sQ<0\204\172\172zN\004\188\248\244\148e\214\168\220\229\148\179l\163\170Y"
          8 1;
        i1 Out_channel.flush t;
        i1 Out_channel.flush t;
        i2 Out_channel.output_byte t 4;
        i1 Out_channel.is_buffered t;
        i2 Out_channel.set_binary_mode t true;
        i2 Out_channel.set_buffered t true;
        i1 Out_channel.is_buffered t;
        i1 Out_channel.pos t;
        i2 Out_channel.output_string t "\231")
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
    Printf.printf "%d\n%!" (i+1)
  done
