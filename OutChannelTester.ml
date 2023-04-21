module Out_channel = struct
  include Out_channel

  let seek ch v = seek ch (Int64.of_int v)
end

let log =
  [
    (* insert log here *)
    ( [
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t -> Out_channel.seek t 24 |> ignore);
        (fun t ->
          Out_channel.output_string t "\149\016r\213n\2428\179\135" |> ignore);
        (fun t -> Out_channel.output_string t ";\027\136\198" |> ignore);
        (fun t -> Out_channel.seek t 6 |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
      ],
      [
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.output_byte t 5 |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.seek t 6 |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.output_string t ">\245\212\232" |> ignore);
      ],
      [
        (fun t -> Out_channel.output_string t "\026j7bY" |> ignore);
        (fun t ->
          Out_channel.output_substring t "\165\250\027\183\184o\228\026\018" 86
            0
          |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.output_char t '\226' |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.output_byte t 46 |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.seek t 6 |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t ->
          Out_channel.output_string t "\204\024\221\234M\188\223;" |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
      ],
      [
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.output_char t '\153' |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.seek t 0 |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.output_byte t 9 |> ignore);
        (fun t -> Out_channel.output_substring t "\208\213\203" 90 3 |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.seek t 8 |> ignore);
        (fun t -> Out_channel.seek t 85 |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
      ],
      [
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t ->
          Out_channel.output_substring t "5\185\030\1532.'s" 42 6 |> ignore);
        (fun t -> Out_channel.output_byte t 3 |> ignore);
        (fun t -> Out_channel.output_substring t "\020\005N" 72 52 |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.output_byte t 8 |> ignore);
        (fun t -> Out_channel.seek t 1 |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.output_string t "B\027\017\222" |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t ->
          Out_channel.output_substring t
            "\202\156C\242b=\002\190\193\128\n\
             \210S\020\202\229\r\012\166\152\176\"\146\214=R?\229erd\199\bf\170=8=\135\180\143\208C1\195\156\183\\\163\208r\246\206\026,\029\140\217;$\250i\219\196[\255\177yH\145\161\n\
             \018\238\222PyE\173\212\131\131o;\222nYG\249"
            1 5
          |> ignore);
        (fun t ->
          Out_channel.output_string t
            "\250e-\0258\b\163\003\244\1938\212\2153\217a\141Yk\149NU72\195\027f\168\023\007 \
             `_S1\157\168T\240\219\161!E\n\
             \220\021\004\228\192\174\196\224\189\030\138=\011\157\189\002\228\165B\210\212\222\028\146\127<0:\175\004\002\141\224\196\191\190h"
          |> ignore);
        (fun t -> Out_channel.output_substring t "\186t&m" 0 8 |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.output_string t "\170J" |> ignore);
        (fun t ->
          Out_channel.output_string t "\162\212\170V\200\230\240\219" |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.output_byte t 6 |> ignore);
        (fun t -> Out_channel.seek t 0 |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.seek t 1 |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
      ],
      [
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t -> Out_channel.output_string t "\237\136$\213\"" |> ignore);
        (fun t -> Out_channel.output_string t "l5\220" |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t ->
          Out_channel.output_substring t "\217J\230\217J\184" 5 9 |> ignore);
        (fun t -> Out_channel.length t |> ignore);
      ],
      [
        (fun t -> Out_channel.seek t 7 |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t ->
          Out_channel.output_substring t "m<\245\238B\136\238\228" 0 2 |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.output_byte t 1 |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.output_char t '\016' |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.seek t 6 |> ignore);
        (fun t -> Out_channel.output_char t '\n' |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.seek t 2 |> ignore);
        (fun t -> Out_channel.output_byte t 6 |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
      ],
      [
        (fun t -> Out_channel.output_substring t "\241f\218\217" 0 0 |> ignore);
        (fun t ->
          Out_channel.output_substring t
            "}\185\179\163\181D\144cW5wf\005\181D\024\185'm\137\217-\156\219`\0221\246\145H\183t#;\139\b"
            1 5
          |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
      ],
      [
        (fun t -> Out_channel.seek t 1 |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t ->
          Out_channel.output_string t
            "\154\152\245\027.p\194zM\022#I$:\207\166\140[6\2422\222gA\1314m\179;F!2\175f\159E\215\001]\019\163_x\249H\022\017|\214nj\252f\141w\197C\235\162?\005\252\207$\179\011\132\014L\209\190h"
          |> ignore);
        (fun t -> Out_channel.seek t 97 |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.output_byte t 2 |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.seek t 8 |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.output_substring t "FNis\001\213" 8 2 |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.output_byte t 4 |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.seek t 4 |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
      ],
      [
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t ->
          Out_channel.output_substring t ".\131\242\247\228\025" 9 7 |> ignore);
        (fun t -> Out_channel.output_char t ')' |> ignore);
        (fun t -> Out_channel.output_substring t "" 2 37 |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.seek t 9 |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.output_char t '\131' |> ignore);
      ],
      [
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.output_char t 'N' |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.output_char t '\r' |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.seek t 4 |> ignore);
        (fun t -> Out_channel.seek t 8 |> ignore);
        (fun t -> Out_channel.output_substring t "ZG\022\023\012" 3 0 |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t ->
          Out_channel.output_substring t "\183\253(\017s\166" 9 3 |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
      ],
      [
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.seek t 1 |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.output_substring t "o\031Q\145" 0 7 |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
      ],
      [
        (fun t -> Out_channel.output_byte t 8 |> ignore);
        (fun t ->
          Out_channel.output_substring t "\174f\154P\166\189b\n\228" 3 4
          |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.seek t 6 |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.output_byte t 2 |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.output_byte t 81 |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.output_substring t "h\030" 4 5 |> ignore);
        (fun t -> Out_channel.seek t 5 |> ignore);
      ],
      [
        (fun t -> Out_channel.seek t 6 |> ignore);
        (fun t -> Out_channel.output_byte t 8 |> ignore);
        (fun t -> Out_channel.output_substring t "\163\005" 8 0 |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
      ],
      [
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.seek t 1 |> ignore);
        (fun t -> Out_channel.output_byte t 2 |> ignore);
        (fun t -> Out_channel.seek t 3 |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.seek t 0 |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.output_substring t "O" 64 5 |> ignore);
        (fun t -> Out_channel.seek t 9 |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
      ],
      [
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
      ],
      [
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
      ] );
    (* -> true *)
    ( [ (fun t -> Out_channel.pos t |> ignore) ],
      [
        (fun t -> Out_channel.output_string t "<\195\227\215\221" |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t ->
          Out_channel.output_substring t
            "\1707NW\000'an\191\015\145\n\
             \236C\250\027\200\185\149\153q\"\179!5B_Q\173\028\243j6yn\129\2209\003<\168\156d)\169\247\212\199Q\031-\152"
            0 4
          |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.output_char t '\021' |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.output_byte t 2 |> ignore);
        (fun t -> Out_channel.seek t 83 |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
      ],
      [
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.output_char t 'x' |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.output_char t '=' |> ignore);
        (fun t ->
          Out_channel.output_substring t "\153\002\213\144\240" 0 39 |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t -> Out_channel.output_char t '\132' |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.output_char t '\188' |> ignore);
        (fun t -> Out_channel.output_substring t "\201\014v\146" 6 7 |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t ->
          Out_channel.output_substring t "\173\255\232\223R\018" 3 0 |> ignore);
      ],
      [
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
      ],
      [
        (fun t -> Out_channel.seek t 0 |> ignore);
        (fun t -> Out_channel.output_byte t 71 |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.seek t 3 |> ignore);
        (fun t -> Out_channel.output_char t '\230' |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.output_char t '\201' |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.output_char t '\128' |> ignore);
        (fun t -> Out_channel.output_byte t 9 |> ignore);
        (fun t -> Out_channel.output_substring t "\174\017\208" 87 25 |> ignore);
        (fun t -> Out_channel.output_char t '\248' |> ignore);
      ],
      [
        (fun t -> Out_channel.output_string t "\192\\\249" |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t ->
          Out_channel.output_string t "\182\211M\226m\141\218\160" |> ignore);
        (fun t ->
          Out_channel.output_string t
            "\203\216\254\023\173]W\0217\209Q\202]\b+\158Z\159\202\205\210U\163~\241!\0279xAq\236\196\200\007[\b\026\211\172\170~\028\189SZ\224\241\242\202c;\181'%f\177\t\2515\184\166O0b\153\n\
             \218\006>\195\003\019'\014\166\130\194H"
          |> ignore);
        (fun t -> Out_channel.close t |> ignore);
      ],
      [
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.output_char t '\201' |> ignore);
        (fun t ->
          Out_channel.output_string t "I\023.\247\158\138\190{\147" |> ignore);
        (fun t ->
          Out_channel.output_string t
            "\181\207\"`\014\160P\151\142\131\250S\213\197\242\165\000\183\182I\215\248K* \
             N\0250}\204K\243*\020\172\208 \
             \134rW\r%\201ut\183KO\031\2212\199\165\205\131\000\\\153CDD\\=\163\157S"
          |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.output_char t ';' |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.pos t |> ignore);
        (fun t ->
          Out_channel.output_substring t "U \182j\186\159\174\170" 6 74
          |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t ->
          Out_channel.output_string t
            "\162\218\004\178`g\206-\025\162\166\246>p\244\"N~\190\166\019\017B\194\206\138%cD\150P\146\228\002#\138T\186\235\178\155s\003\129\199\237h$\145\176i\001\231Ukp\002\1419Y\190\137\202!><\"N\158}\178"
          |> ignore);
        (fun t -> Out_channel.output_substring t "j\026\210\025" 75 0 |> ignore);
        (fun t ->
          Out_channel.output_substring t "\2487\158\220\150" 5 7 |> ignore);
        (fun t ->
          Out_channel.output_string t "\166\204\153-\222l\011" |> ignore);
        (fun t -> Out_channel.output_char t '\245' |> ignore);
        (fun t -> Out_channel.seek t 7 |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.output_char t '\179' |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
      ],
      [
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.seek t 0 |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
      ],
      [
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.output_char t '\161' |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.seek t 0 |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.output_char t '\219' |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.output_byte t 0 |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.output_string t "\157a\133\135\028c" |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.output_byte t 1 |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
      ],
      [
        (fun t -> Out_channel.output_char t '\138' |> ignore);
        (fun t -> Out_channel.seek t 2 |> ignore);
        (fun t -> Out_channel.output_byte t 9 |> ignore);
        (fun t -> Out_channel.seek t 87 |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.output_char t '\184' |> ignore);
      ],
      [
        (fun t -> Out_channel.output_substring t "I\r\208\129" 7 1 |> ignore);
        (fun t -> Out_channel.output_char t '\233' |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.output_byte t 5 |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t ->
          Out_channel.output_string t ";\183O\158#\022\213\177\233" |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.seek t 0 |> ignore);
      ],
      [
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.output_byte t 0 |> ignore);
        (fun t -> Out_channel.seek t 7 |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t ->
          Out_channel.output_string t
            "I4?Gl\214\rZfy+\202\148\134\210\168\184\n\
             \155\187H.\173D\143\210$\180!\027\019\029(E\245\167\229U\144F\230\143Xd1\139igC\185;\0052W\175\151\13579<\2023\207\173\r!\022\018\237"
          |> ignore);
        (fun t -> Out_channel.output_char t '\208' |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
      ],
      [
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.output_string t "\134=4W\251{" |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.output_string t "T\194\244\232" |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.output_byte t 8 |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.output_substring t "0@q\241\237`" 7 2 |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
      ],
      [
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
      ],
      [
        (fun t ->
          Out_channel.output_string t
            "\229\196\187\244\012\131\163&w\140YV\223m\245\219\204"
          |> ignore);
        (fun t -> Out_channel.output_string t "\027\011" |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.output_byte t 3 |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.output_byte t 2 |> ignore);
      ],
      [
        (fun t -> Out_channel.output_substring t "/\224\193\182" 1 7 |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.output_substring t "|\150" 8 6 |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.output_substring t "\n#'" 3 15 |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.seek t 0 |> ignore);
      ],
      [
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.seek t 6 |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.output_string t "\017\217\003" |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.output_char t '\138' |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.seek t 9 |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.output_substring t "" 8 58 |> ignore);
        (fun t ->
          Out_channel.output_substring t "$\0024\191\232\017\145O\129" 23 2
          |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.output_char t '\028' |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t ->
          Out_channel.output_string t "\221s\211\205}J2\153\184" |> ignore);
        (fun t -> Out_channel.output_char t '\254' |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
      ],
      [
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
      ],
      [
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.output_string t "sZ2" |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t ->
          Out_channel.output_string t
            "<\189\030\197\133#\003\246\150\006\249\182|f\2247rJ \
             \199\145#t\220\142\225/\183\134\183\216\188\018\011\1927\234\229N^\218\185\027'\195\003\246\128\225c\220\220\168\028!"
          |> ignore);
        (fun t -> Out_channel.output_byte t 6 |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
      ],
      [
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.output_byte t 9 |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t ->
          Out_channel.output_substring t
            "Q\014\195\164\171\181\209\219W\152\135\012\196Sz?N\139\142\237\180\222g\200i,=<>\210\232\005\224]\136xA\197\001-\2352l\215\188\154\232\207\017\225`z\201\245\136q\152\167/z\172\136"
            8 2
          |> ignore);
        (fun t ->
          Out_channel.output_string t "a\151\200\025S\158\187" |> ignore);
      ],
      [
        (fun t ->
          Out_channel.output_string t "\210\\\028\179}\140\163@\183" |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.output_char t '\142' |> ignore);
        (fun t -> Out_channel.output_byte t 29 |> ignore);
        (fun t -> Out_channel.output_byte t 7 |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.output_string t "\rn\195\221" |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.seek t 9 |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
      ],
      [
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.output_byte t 4 |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t ->
          Out_channel.output_substring t "\218F\154\229\255E\019\176 " 9 2
          |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
      ],
      [
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.output_string t "" |> ignore);
        (fun t -> Out_channel.output_substring t ":\148" 35 26 |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.output_char t '|' |> ignore);
        (fun t -> Out_channel.output_char t '\r' |> ignore);
        (fun t -> Out_channel.output_byte t 2 |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.output_byte t 6 |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.seek t 2 |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.output_string t "\157" |> ignore);
      ],
      [
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
      ],
      [
        (fun t -> Out_channel.output_char t '\017' |> ignore);
        (fun t -> Out_channel.output_char t '\005' |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.output_char t '\161' |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.seek t 61 |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.seek t 15 |> ignore);
        (fun t -> Out_channel.seek t 4 |> ignore);
        (fun t -> Out_channel.output_byte t 5 |> ignore);
        (fun t -> Out_channel.output_byte t 3 |> ignore);
        (fun t ->
          Out_channel.output_substring t
            "\138\015P&C\003\253\189h\214d,\153,\146L!\248\025_\1866\221)Pa\131>R\248:\203\155"
            6 2
          |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.output_char t '8' |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.output_char t '\140' |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.length t |> ignore);
      ],
      [
        (fun t -> Out_channel.output_string t "" |> ignore);
        (fun t -> Out_channel.output_string t "" |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t ->
          Out_channel.output_string t "\161h\171\199*\204\174" |> ignore);
        (fun t -> Out_channel.seek t 8 |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
      ],
      [
        (fun t -> Out_channel.output_char t '\019' |> ignore);
        (fun t -> Out_channel.output_char t '\005' |> ignore);
        (fun t -> Out_channel.output_char t 'n' |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.seek t 7 |> ignore);
        (fun t -> Out_channel.output_char t 'X' |> ignore);
        (fun t ->
          Out_channel.output_string t
            "\007E\132A\172\143\141\172\236\186i\230N\167\b\213O\128^\231\243\030\014x.\194\025\t\029\168\020M%\242/C\182_\159'-B3\200\239\201l\242\005t\198X\207\1463\181\221\023R\\\225\184W\247\250\024\183\142\181\142\200\142(\156\179\136A\225\163\250\202\224\n"
          |> ignore);
        (fun t ->
          Out_channel.output_string t
            "\143\191\162\239\194)}\2094!\017^\250#\148\193:\243%36 \
             !\236\197\022`\188\0119y\232"
          |> ignore);
        (fun t -> Out_channel.length t |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.seek t 9 |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.output_byte t 2 |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
      ],
      [
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t -> Out_channel.seek t 9 |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.close t |> ignore);
      ],
      [
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.output_substring t "/\158\194\023" 8 2 |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.output_string t "\146\200\151\207\137t" |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
      ],
      [
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.output_char t 'k' |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t ->
          Out_channel.output_substring t "\023{\250\155%\217\148" 7 5 |> ignore);
        (fun t -> Out_channel.seek t 2 |> ignore);
        (fun t -> Out_channel.output_byte t 0 |> ignore);
        (fun t -> Out_channel.length t |> ignore);
      ],
      [
        (fun t -> Out_channel.output_char t '\196' |> ignore);
        (fun t -> Out_channel.output_char t '\025' |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.output_string t "\026O\201\159\185\024" |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.output_char t '\159' |> ignore);
        (fun t -> Out_channel.output_char t '\138' |> ignore);
        (fun t ->
          Out_channel.output_substring t "=\251L\219k\018]39" 6 3 |> ignore);
        (fun t -> Out_channel.seek t 8 |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.length t |> ignore);
      ],
      [
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.seek t 74 |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.output_char t '\210' |> ignore);
      ],
      [
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.output_char t '\136' |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.seek t 0 |> ignore);
        (fun t ->
          Out_channel.output_substring t "\178x^\156\163\185 " 2 0 |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
      ],
      [
        (fun t -> Out_channel.output_byte t 75 |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t -> Out_channel.output_char t '\224' |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.seek t 50 |> ignore);
        (fun t ->
          Out_channel.output_string t "\233\169\127\023l\201\247\250" |> ignore);
      ],
      [
        (fun t -> Out_channel.seek t 3 |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.output_substring t "" 4 4 |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.seek t 8 |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.output_byte t 8 |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.output_byte t 2 |> ignore);
        (fun t -> Out_channel.set_buffered t false |> ignore);
      ],
      [
        (fun t -> Out_channel.seek t 3 |> ignore);
        (fun t -> Out_channel.seek t 2 |> ignore);
        (fun t -> Out_channel.output_substring t "x\185" 6 5 |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.length t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
      ],
      [
        (fun t -> Out_channel.output_substring t "\016\162" 6 7 |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.seek t 14 |> ignore);
        (fun t -> Out_channel.output_char t '\006' |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.output_char t 'Q' |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.output_char t '\230' |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.output_string t "\232" |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.output_char t 'q' |> ignore);
        (fun t -> Out_channel.output_char t '=' |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.seek t 4 |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.output_substring t "" 58 0 |> ignore);
        (fun t ->
          Out_channel.output_substring t "G\016\024\167" 60 34 |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.close t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.output_char t '\242' |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
      ],
      [
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.output_char t '\'' |> ignore);
      ],
      [
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.output_byte t 7 |> ignore);
      ] );
    (* -> true *)
    ( [
        (fun t -> Out_channel.output_byte t 74 |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.output_substring t "\030" 3 3 |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.output_char t '\178' |> ignore);
        (fun t ->
          Out_channel.output_string t "\165Q\195J\152\228\230" |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
      ],
      [
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.output_string t "\031}" |> ignore);
        (fun t ->
          Out_channel.output_substring t
            "\005s\158\014\166\202\\I\221up\145\222\219sa18d\028\019\127\198\230{j#J+\019u\1690P \
             m\150\225\230F\184z\243\165\191!cG\206g\137\132v\143\176d(\214P\149\194\181\001\150\212\\c\027M\028u)"
            5 3
          |> ignore);
        (fun t -> Out_channel.output_byte t 3 |> ignore);
        (fun t -> Out_channel.output_byte t 85 |> ignore);
        (fun t ->
          Out_channel.output_substring t "\206\145\227\210Y>\230\195" 1 30
          |> ignore);
        (fun t -> Out_channel.set_binary_mode t false |> ignore);
        (fun t -> Out_channel.flush_all () |> ignore);
        (fun t ->
          Out_channel.output_string t "1I-u\184\192\"\207\159" |> ignore);
        (fun t -> Out_channel.output_byte t 8 |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
        (fun t -> Out_channel.close_noerr t |> ignore);
      ],
      [
        (fun t -> Out_channel.set_buffered t false |> ignore);
        (fun t -> Out_channel.output_char t '`' |> ignore);
        (fun t ->
          Out_channel.output_substring t
            "\157\159/I\178\030\182g\144c\0048\0284sQ<0\204\172\172zN\004\188\248\244\148e\214\168\220\229\148\179l\163\170Y"
            8 1
          |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.flush t |> ignore);
        (fun t -> Out_channel.output_byte t 4 |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.set_binary_mode t true |> ignore);
        (fun t -> Out_channel.set_buffered t true |> ignore);
        (fun t -> Out_channel.is_buffered t |> ignore);
        (fun t -> Out_channel.pos t |> ignore);
        (fun t -> Out_channel.output_string t "\231" |> ignore);
      ] );
  ]

let tester (tk0, tk1, tk2) =
  let path, t = Filename.open_temp_file "out-channel-" "" in
  let run thunk = try thunk t with _ -> () in

  List.iter run tk0;

  let wait = Atomic.make true in
  let dom1 =
    Domain.spawn (fun () ->
        while Atomic.get wait do
          Domain.cpu_relax ()
        done;
        List.iter run tk1)
  in

  let dom2 =
    Domain.spawn (fun () ->
        Atomic.set wait false;
        List.iter run tk2)
  in

  let _ = Domain.join dom1 in
  let _ = Domain.join dom2 in

  Out_channel.close t;
  Sys.remove path

let _ =
  for i = 1 to 1000 do
    List.iter
      (fun x ->
        for _j = 1 to 50 do
          tester x
        done)
      log;
    Printf.printf "%d\n%!" i
  done
