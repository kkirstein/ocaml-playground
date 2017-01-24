#
# Makefile for Machine Learning tools
#

OCB_FLAGS = -use-ocamlfind -no-links
OCB_FLAGS_TEST = -use-ocamlfind -cflags -warn-error,+26 -no-links
OCB = ocamlbuild

main = benchmark
main_test = test_runner
test_sources = lib/color_map.ml lib/fibonacci.ml \
	lib/image.ml lib/mandelbrot.ml lib/perfect_number.ml
clib = perfect_number_stubs

all: native byte # profile debug

clean:
	#$(OCB) -clean
	rm -rf _build
	rm -f $(main).native
	rm -f $(main).byte
	rm -f $(main_test).ml


native:
	rm -f $(main).native
#	$(OCB) -cflags -ccopt,-fopenmp lib/perfect_number_stubs.o
	$(OCB) lib/perfect_number_stubs.o
	$(OCB) $(main).native $(OCB_FLAGS) -lflags lib/perfect_number_stubs.o

byte:
	rm -f $(main).byte
	$(OCB) lib/perfect_number_stubs.o
	$(OCB) $(main).byte $(OCB_FLAGS) -lflags -custom,lib/perfect_number_stubs.o

profile:
	$(OCB) $(OCB_FLAGS) -tag profile _build/$(main).native

debug:
	$(OCB) $(OCB_FLAGS) -tag debug _build/$(main).byte

run: native
	_build/$(main).native

# build c stubs
.o:.c
	$(OCB) $@

# iTeML tests
$(main_test).ml: $(test_sources)
	qtest -o $@ extract $^

test: $(main_test).ml
	$(OCB) lib/perfect_number_stubs.o
	$(OCB) $(main_test).native $(OCB_FLAGS_TEST) -lflags lib/perfect_number_stubs.o
	_build/$(main_test).native

.PHONY: 	all clean byte native profile debug test
