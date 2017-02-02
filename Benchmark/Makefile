#
# Makefile for Machine Learning tools
#

OCB_FLAGS = -use-ocamlfind -no-links  -lflags lib/perfect_number_stubs.o
OCB_FLAGS_TEST = -use-ocamlfind -cflags -warn-error,+26 -no-links -lflags lib/perfect_number_stubs.o
OCB = ocamlbuild

# C compiler setup
CC = $(shell ocamlc -config | awk 'BEGIN {FS=":"} /native_c_compiler/ { print $$2 }')
#CFLAGS = -cflags -ccopt,-static,-ccopt,-fopenmp
CFLAGS = -fPIC

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


native: clibs
	rm -f $(main).native
#	$(OCB) -cflags -ccopt,-fopenmp lib/perfect_number_stubs.o
	$(OCB)  $(main).native $(OCB_FLAGS)

byte: clibs
	rm -f $(main).byte
	$(OCB) $(main).byte $(OCB_FLAGS) -lflags -custom

profile:
	$(OCB) $(OCB_FLAGS) -tag profile _build/$(main).native

debug:
	$(OCB) $(OCB_FLAGS) -tag debug _build/$(main).byte

run: native
	_build/$(main).native

# build c stubs
clibs:
	mkdir -p _build/lib
#	$(CC) $(CFLAGS) lib/perfect_number_stubs.c -shared -o _build/lib/libpn.so
	$(CC) $(CFLAGS) -c lib/perfect_number_stubs.c -o _build/lib/perfect_number_stubs.o

# iTeML tests
$(main_test).ml: $(test_sources)
	qtest -o $@ extract $^

test: clibs $(main_test).ml
	$(OCB) $(main_test).native $(OCB_FLAGS_TEST)
	_build/$(main_test).native

.PHONY: 	all clean byte native clibs profile debug test
