open Stm_tests_spec_ref

module RT_int   = STM_domain.Make(RConf_int)
module RT_int64 = STM_domain.Make(RConf_int64)
;;
QCheck_base_runner.run_tests_main
  [RT_int.agree_test_par        ~count:1000 ~name:"STM int ref test parallel";
  ]
