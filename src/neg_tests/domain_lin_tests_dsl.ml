open Lin_tests_common_dsl

(** This is a driver of the negative tests over the Domain module *)

;;
Util.set_ci_printing ()
;;
QCheck_base_runner.run_tests_main
  (let count = 10000 in
   [RT_int_domain.neg_lin_test    ~count ~name:"Lin_api ref int test with Domain";
    RT_int64_domain.neg_lin_test  ~count ~name:"Lin_api ref int64 test with Domain";
    CLT_int_domain.neg_lin_test   ~count ~name:"Lin_api CList int test with Domain";
    CLT_int64_domain.neg_lin_test ~count ~name:"Lin_api CList int64 test with Domain"])
