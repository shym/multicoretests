OutChannelTester.exe: OutChannelTester.ml
	ocamlopt.opt -runtime-variant=d -g -o $@ $<
