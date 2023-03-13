_: bufferstress.bc
	ocamlrund $<

bufferstress.bc: bufferstress.ml
	ocamlc -g -o $@ $<
