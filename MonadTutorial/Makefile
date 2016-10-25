#
# Makefile for Machine Learning tools
#

OCB_FLAGS = -use-ocamlfind
OCB = ocamlbuild $(OCB_FLAGS)

main = kv_test

all: native byte # profile debug

clean:
	#$(OCB) -clean
	rm -rf _build
	rm -f $(main).native
	rm -f $(main).byte

native:
	rm -f $(main).native
	$(OCB) $(main).native

byte:
	rm -f $(main).byte
	$(OCB) $(main).byte

profile:
	$(OCB) -tag profile $(main).native

debug:
	$(OCB) -tag debug $(main).byte

test: native
	./$(main).native

.PHONY: 	all clean byte native profile debug test
