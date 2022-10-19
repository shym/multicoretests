open Lin_tests_common

(** This is a driver of the negative tests over the Thread module *)

module RT_int_thread = Lin_thread.Make_internal(RConf_int)
module RT_int64_thread = Lin_thread.Make_internal(RConf_int64)
module CLT_int_thread = Lin_thread.Make_internal(CLConf (Int))
module CLT_int64_thread = Lin_thread.Make_internal(CLConf (Int64))

;;
Util.set_ci_printing ()
;;
QCheck_base_runner.run_tests_main
  (let count = 1000 in
   [RT_int_thread.lin_test       ~count ~name:"Lin ref int test with Thread"; (* unboxed, hence no allocations to trigger context switch *)
    RT_int64_thread.neg_lin_test ~count:15000 ~name:"Lin ref int64 test with Thread";
    CLT_int_thread.lin_test      ~count ~name:"Lin CList int test with Thread"; (* unboxed, hence no allocations to trigger context switch *)
    CLT_int64_thread.lin_test    ~count ~name:"Lin CList int64 test with Thread"]) (* not triggering context switch, unfortunately *)
