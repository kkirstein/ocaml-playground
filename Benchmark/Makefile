#
# Makefile for Machine Learning tools
#

OCB_FLAGS = -use-ocamlfind -no-links -lflags lib/libpn.a
OCB_FLAGS_TEST = -use-ocamlfind -cflags -warn-error,+26 -no-links -lflag lib/libpn.a
OCB = ocamlbuild

#CFLAGS = -cflags -ccopt,-static,-ccopt,-fopenmp
CFLAGS =

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
	$(OCB) $(CFLAGS) libpn.a
	$(OCB)  $(main).native $(OCB_FLAGS)

byte:
	rm -f $(main).byte
	$(OCB) $(CFLAGS) libpn.a
	$(OCB) $(main).byte $(OCB_FLAGS) -lflags -custom

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
	$(OCB) $(CFLAGS) libpn.a
	$(OCB) $(main_test).native $(OCB_FLAGS_TEST)
	_build/$(main_test).native

.PHONY: 	all clean byte native profile debug test
