open Ref_stm_spec

module RT_int_Seq   = STM_sequential.Make(RConf_int)
module RT_int64_Seq = STM_sequential.Make(RConf_int64)
;;
Util.set_ci_printing ()
;;
QCheck_runner.run_tests_main
  (let count = 1000 in
   [RT_int_Seq.agree_test   ~count ~name:"global int ref test sequential";
    RT_int64_Seq.agree_test ~count ~name:"global int64 ref test sequential";
   ])
