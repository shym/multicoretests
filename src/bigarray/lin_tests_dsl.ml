(* ********************************************************************** *)
(*           Tests of thread-unsafe [Bigarray.Array1] of ints             *)
(* ********************************************************************** *)

module BA1Conf =
struct
  open Bigarray
  type t = (int, int_elt, c_layout) Array1.t

  let array_size = 16
  let init () =
    let arr = Array1.create int C_layout array_size in
    Array1.fill arr 0 ;
    arr
  let cleanup _ = ()

  open Lin
  let int = int_small

  let api =
    [ (* Only one t is tested, so skip functions that create arrays or
         take multiple arrays as input *)
      (* init *)
      val_ "Bigarray.Array1.dim"           Array1.dim           (t @-> returning int);
      (* kind and layout types would require specific configurations *)
      (* kind *)
      (* layout *)
      (* change_layout *)
      val_ "Bigarray.Array1.size_in_bytes" Array1.size_in_bytes (t @-> returning int);
      val_ "Bigarray.Array1.get"           Array1.get           (t @-> int @-> returning_or_exc int);
      val_ "Bigarray.Array1.set"           Array1.set           (t @-> int @-> int @-> returning_or_exc unit);
      (* sub *)
      (* slice (generate an Array0) *)
      (* blit *)
      val_ "Bigarray.Array1.fill"          Array1.fill          (t @-> int @-> returning unit);
      (* of_array *)
    ]
end

module BA1T = Lin_domain.Make(BA1Conf)

let _ =
  QCheck_base_runner.run_tests_main [
    BA1T.neg_lin_test ~count:5000 ~name:"Lin DSL Bigarray.Array1 (of ints) test with Domain";
  ]
