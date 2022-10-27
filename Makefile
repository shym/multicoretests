all: effect_lin_tests_dsl.bc

include .deps

effect_lin_tests_dsl.bc: lib/util.cmo lib/lin.cmo lib/lin_api.cmo src/neg_tests/CList.cmo src/neg_tests/lin_tests_common_dsl.cmo src/neg_tests/effect_lin_tests_dsl.cmo
	ocamlfind ocamlc -g $^ -o $@ -package qcheck-core,qcheck-core.runner -linkpkg -thread

%.cmi: %.mli
	ocamlfind ocamlc -c -g $< -o $@ -package qcheck-core -I lib -thread

%.cmo: %.ml
	ocamlfind ocamlc -c -g $< -o $@ -package qcheck-core,qcheck-core.runner -I lib -I src/neg_tests -thread

look-for-seed: effect_lin_tests_dsl.bc
	set -e;                 \
	export CI=true;         \
	for i in `seq 200`; do  \
		ocamlrun $< -v; \
	done

.deps:
	ocamldep -I lib -I src/neg_tests lib/* lib/* src/neg_tests/* > $@

clean:
	rm -f effect_lin_tests_dsl.bc */*.cm[io] */*/*.cm[io] .deps

.PHONY: all clean look-for-seed
