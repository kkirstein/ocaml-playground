#
# Makefile for Machine Learning tools
#

OCB_FLAGS = -use-ocamlfind
OCB_FLAGS_TEST = -use-ocamlfind -no-links
OCB = ocamlbuild

main = benchmark
main_test = benchmark_test
test_sources = lib/color_map.ml lib/fibonacci.ml \
	lib/image.ml lib/mandelbrot.ml lib/Perfect_number.ml

all: native byte # profile debug

clean:
	#$(OCB) -clean
	rm -rf _build
	rm -f $(main).native
	rm -f $(main).byte
	rm -f $(main_test).ml


native:
	rm -f $(main).native
	$(OCB) $(OCB_FLAGS) $(main).native

byte:
	rm -f $(main).byte
	$(OCB) $(OCB_FLAGS) $(main).byte

profile:
	$(OCB) $(OCB_FLAGS) -tag profile $(main).native

debug:
	$(OCB) $(OCB_FLAGS) -tag debug $(main).byte

run: native
	./$(main).native

# iTeML tests
$(main_test).ml: $(test_sources)
	qtest -o $@ extract $^

test: $(main_test).ml
	$(OCB) $(OCB_FLAGS_TEST) $(main_test).native
	_build/$(main_test).native

.PHONY: 	all clean byte native profile debug test
