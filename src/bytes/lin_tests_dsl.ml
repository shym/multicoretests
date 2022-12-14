(* ********************************************************************** *)
(*                      Tests of thread-unsafe [Bytes]                    *)
(* ********************************************************************** *)
module BConf = struct
  type t = Bytes.t
  let init () = Stdlib.Bytes.make 42 '0'
  let cleanup _ = ()

  open Lin

  let api = [
    (* Only one t is tested, so skip functions that create Bytes.t or
       take multiple Bytes.t as input;
       skip functions using UChar;
       skip higher-order functions *)
    val_ "Bytes.get"         Bytes.get         (t @-> int @-> returning_or_exc char);
    val_ "Bytes.set"         Bytes.set         (t @-> int @-> char @-> returning_or_exc unit);
    (* create *)
    (* make *)
    (* init *)
    (* empty *)
    (* copy *)
    (* of_string *)
    val_ "Bytes.to_string"   Bytes.to_string   (t @-> returning string);
    (* sub *)
    val_ "Bytes.sub_string"  Bytes.sub_string  (t @-> int @-> int @-> returning_or_exc string);
    (* extend *)
    val_ "Bytes.length"      Bytes.length      (t @-> returning int);
    val_ "Bytes.fill"        Bytes.fill        (t @-> int @-> int @-> char @-> returning_or_exc unit);
    (* blit *)
    val_ "Bytes.blit_string" Bytes.blit_string (string @-> int @-> t @-> int @-> int @-> returning_or_exc unit);
    (* concat *)
    (* cat *)
    (* iter *)
    (* iteri *)
    (* map *)
    (* mapi *)
    (* fold_left *)
    (* fold_right *)
    (* for_all *)
    (* exists *)
    (* trim *)
    (* escaped *)
    val_ "Bytes.index"       Bytes.index       (t @-> char @-> returning_or_exc int);
    val_ "Bytes.index_opt"   Bytes.index_opt   (t @-> char @-> returning_or_exc (option int));
    val_ "Bytes.rindex"      Bytes.rindex      (t @-> char @-> returning_or_exc int);
    val_ "Bytes.rindex_opt"  Bytes.rindex_opt  (t @-> char @-> returning_or_exc (option int));
    val_ "Bytes.index_from"      Bytes.index_from      (t @-> int @-> char @-> returning_or_exc int);
    val_ "Bytes.index_from_opt"  Bytes.index_from_opt  (t @-> int @-> char @-> returning_or_exc (option int));
    val_ "Bytes.rindex_from"     Bytes.rindex_from     (t @-> int @-> char @-> returning_or_exc int);
    val_ "Bytes.rindex_from_opt" Bytes.rindex_from_opt (t @-> int @-> char @-> returning_or_exc (option int));
    val_ "Bytes.contains"           Bytes.contains           (t @-> char @-> returning bool);
    val_ "Bytes.contains_from"      Bytes.contains_from      (t @-> int @-> char @-> returning_or_exc bool);
    val_ "Bytes.rcontains_from"     Bytes.rcontains_from     (t @-> int @-> char @-> returning_or_exc bool);
    (* val_ "Bytes.uppercase_ascii"    Bytes.uppercase_ascii    (t @-> returning t); *)
    (* val_ "Bytes.lowercase_ascii"    Bytes.lowercase_ascii    (t @-> returning t); *)
    (* val_ "Bytes.capitalize_ascii"   Bytes.capitalize_ascii   (t @-> returning t); *)
    (* val_ "Bytes.uncapitalize_ascii" Bytes.uncapitalize_ascii (t @-> returning t); *)
    (* val_ "Bytes.compare"            Bytes.compare            (t @-> t @-> returning int); *)
    (* val_ "Bytes.equal"              Bytes.equal              (t @-> t @-> returning bool); *)
    (* val_ "Bytes.starts_with"        Bytes.starts_with        (t @-> t @-> returning bool); *)
    (* val_ "Bytes.ends_with"          Bytes.ends_with          (t @-> t @-> returning bool); *)
    (* val_ "Bytes.split_on_char"      Bytes.split_on_char      (char @-> t @-> returning (list t)); *)
    (* val_ "Bytes.to_seq"             Bytes.to_seq             (t @-> char returning Seq.t); *)
    (* val_ "Bytes.to_seqi"            Bytes.to_seqi            (t @-> (int * char) returning Seq.t); *)
    (* val_ "Bytes.of_seq"             Bytes.of_seq             (char Seq.t @-> returning t); *)
    (* val_ "Bytes.get_utf_8_uchar"    Bytes.get_utf_8_uchar    (t @-> int @-> returning Uchar.utf_decode); *)
    (* val_ "Bytes.set_utf_8_uchar"    Bytes.set_utf_8_uchar    (t @-> int @-> Uchar.t @-> returning int); *)
    val_ "Bytes.is_valid_utf_8"     Bytes.is_valid_utf_8     (t @-> returning bool);
    (* val_ "Bytes.get_utf_16be_uchar" Bytes.get_utf_16be_uchar (t @-> int @-> returning Uchar.utf_decode); *)
    (* val_ "Bytes.set_utf_16be_uchar" Bytes.set_utf_16be_uchar (t @-> int @-> Uchar.t @-> returning int); *)
    val_ "Bytes.is_valid_utf_16be"  Bytes.is_valid_utf_16be  (t @-> returning bool);
    (* val_ "Bytes.get_utf_16le_uchar" Bytes.get_utf_16le_uchar (t @-> int @-> returning Uchar.utf_decode); *)
    (* val_ "Bytes.set_utf_16le_uchar" Bytes.set_utf_16le_uchar (t @-> int @-> Uchar.t @-> returning int); *)
    val_ "Bytes.is_valid_utf_16le"  Bytes.is_valid_utf_16le  (t @-> returning bool);
    val_ "Bytes.get_uint8"          Bytes.get_uint8          (t @-> int @-> returning_or_exc int);
    val_ "Bytes.get_int8"           Bytes.get_int8           (t @-> int @-> returning_or_exc int);
    val_ "Bytes.get_uint16_ne"      Bytes.get_uint16_ne      (t @-> int @-> returning_or_exc int);
    val_ "Bytes.get_uint16_be"      Bytes.get_uint16_be      (t @-> int @-> returning_or_exc int);
    val_ "Bytes.get_uint16_le"      Bytes.get_uint16_le      (t @-> int @-> returning_or_exc int);
    val_ "Bytes.get_int16_ne"       Bytes.get_int16_ne       (t @-> int @-> returning_or_exc int);
    val_ "Bytes.get_int16_be"       Bytes.get_int16_be       (t @-> int @-> returning_or_exc int);
    val_ "Bytes.get_int16_le"       Bytes.get_int16_le       (t @-> int @-> returning_or_exc int);
    val_ "Bytes.get_int32_ne"       Bytes.get_int32_ne       (t @-> int @-> returning_or_exc int32);
    val_ "Bytes.get_int32_be"       Bytes.get_int32_be       (t @-> int @-> returning_or_exc int32);
    val_ "Bytes.get_int32_le"       Bytes.get_int32_le       (t @-> int @-> returning_or_exc int32);
    val_ "Bytes.get_int64_ne"       Bytes.get_int64_ne       (t @-> int @-> returning_or_exc int64);
    val_ "Bytes.get_int64_be"       Bytes.get_int64_be       (t @-> int @-> returning_or_exc int64);
    val_ "Bytes.get_int64_le"       Bytes.get_int64_le       (t @-> int @-> returning_or_exc int64);
    val_ "Bytes.set_uint8"          Bytes.set_uint8          (t @-> int @-> int @-> returning_or_exc unit);
    val_ "Bytes.set_int8"           Bytes.set_int8           (t @-> int @-> int @-> returning_or_exc unit);
    val_ "Bytes.set_uint16_ne"      Bytes.set_uint16_ne      (t @-> int @-> int @-> returning_or_exc unit);
    val_ "Bytes.set_uint16_be"      Bytes.set_uint16_be      (t @-> int @-> int @-> returning_or_exc unit);
    val_ "Bytes.set_uint16_le"      Bytes.set_uint16_le      (t @-> int @-> int @-> returning_or_exc unit);
    val_ "Bytes.set_int16_ne"       Bytes.set_int16_ne       (t @-> int @-> int @-> returning_or_exc unit);
    val_ "Bytes.set_int16_be"       Bytes.set_int16_be       (t @-> int @-> int @-> returning_or_exc unit);
    val_ "Bytes.set_int16_le"       Bytes.set_int16_le       (t @-> int @-> int @-> returning_or_exc unit);
    val_ "Bytes.set_int32_ne"       Bytes.set_int32_ne       (t @-> int @-> int32 @-> returning_or_exc unit);
    val_ "Bytes.set_int32_be"       Bytes.set_int32_be       (t @-> int @-> int32 @-> returning_or_exc unit);
    val_ "Bytes.set_int32_le"       Bytes.set_int32_le       (t @-> int @-> int32 @-> returning_or_exc unit);
    val_ "Bytes.set_int64_ne"       Bytes.set_int64_ne       (t @-> int @-> int64 @-> returning_or_exc unit);
    val_ "Bytes.set_int64_be"       Bytes.set_int64_be       (t @-> int @-> int64 @-> returning_or_exc unit);
    val_ "Bytes.set_int64_le"       Bytes.set_int64_le       (t @-> int @-> int64 @-> returning_or_exc unit);
    ]
end

module BT_domain = Lin_domain.Make(BConf)
module BT_thread = Lin_thread.Make(BConf) [@alert "-experimental"]
;;
QCheck_base_runner.run_tests_main [
  BT_domain.lin_test ~count:1000 ~name:"Lin DSL Bytes test with Domain";
  BT_thread.lin_test ~count:1000 ~name:"Lin DSL Bytes test with Thread";
]
