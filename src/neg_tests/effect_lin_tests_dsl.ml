open Lin_api

module Spec : Lin_api.ApiSpec = struct
  type t = int ref

  let init () = ref 0
  let add r i = let old = !r in r:= i + old
  let incr r = add r 1
  let decr r = add r (-1)
  let add' r i = let old = !r in Lin.yield (); r := old+i

  let cleanup _ = ()
  let api =
    [ val_ "add"  add'  (t @-> int @-> returning_or_exc unit);
      val_ "incr" incr  (t @-> returning unit);
      val_ "decr" decr  (t @-> returning unit);
    ]
  end

module RT = Lin_api.Make(Spec)

;;
Util.set_ci_printing ()
;;
QCheck_base_runner.run_tests_main
  (let count = 20_000 in [
      (* These tests are negative - and are expected to fail with exception `Unhandled` *)
      RT.neg_lin_test    `Effect ~count ~name:"negative Lin_api ref int test with Effect";
    ])
