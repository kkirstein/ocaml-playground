#
# Makefile for Machine Learning tools
#

# platform dependent settings
UNAME_S = $(shell uname -s)
ifeq (UNAME_S, win)
	EXT_EXE = .exe
else
	EXT_EXE =
endif

OCB_FLAGS = -use-ocamlfind -no-links -lflags lib/perfect_number_stubs.o
OCB_FLAGS_TEST = -use-ocamlfind -no-links -lflags lib/perfect_number_stubs.o
OCB = ocamlbuild

# C compiler setup
CC = $(shell ocamlc -config | awk 'BEGIN {FS=":"} /native_c_compiler/ { print $$2 }')
#CFLAGS = -cflags -ccopt,-static,-ccopt,-fopenmp
CFLAGS = -fPIC

main = benchmark
main_test = test_runner
worker = pn_worker
test_sources = lib/color_map.ml lib/fibonacci.ml \
	lib/image.ml lib/mandelbrot.ml lib/perfect_number.ml
clib = perfect_number_stubs

all: native byte # profile debug

clean:
	#$(OCB) -clean
	rm -rf _build

distclean: clean
	rm -rf dist

native: clibs
	rm -f $(main).native
#	$(OCB) -cflags -ccopt,-fopenmp lib/perfect_number_stubs.o
	$(OCB) $(main).native $(OCB_FLAGS)
	$(OCB) $(worker).native $(OCB_FLAGS)

byte: clibs
	rm -f $(main).byte
	$(OCB) $(main).byte $(OCB_FLAGS) -lflags -custom
	$(OCB) $(worker).byte $(OCB_FLAGS) -lflags -custom

profile:
	$(OCB) $(OCB_FLAGS) -tag profile _build/$(main).native

debug:
	$(OCB) $(OCB_FLAGS) -tag debug _build/$(main).byte

run: native
	_build/bin/$(main).native

# build c stubs
clibs:
	mkdir -p _build/lib
	#$(CC) $(CFLAGS) lib/perfect_number_stubs.c -shared -o _build/lib/libpn.so
	#$(CC) $(CFLAGS) -c lib/perfect_number_stubs.c -o _build/lib/perfect_number_stubs.o
	$(OCB) lib/libpn.a

# iTeML tests
$(main_test).ml: $(test_sources)
	qtest -o ./bin/$@ extract $^

test: clibs $(main_test).ml
	$(OCB) $(main_test).native $(OCB_FLAGS_TEST)
	_build/bin/$(main_test).native

# make distribution package (folder)
dist: native
	rm -rf dist
	mkdir -p dist
	cp _build/bin/$(main).native ./dist/$(main)$(EXT_EXE)
	cp _build/bin/$(worker).native ./dist/$(worker)$(EXT_EXE)
	ldd ./dist/$(main)$(EXT_EXE) ./dist/$(worker)$(EXT_EXE) | awk '$$2  == "=>" && $$3 !~ /WINDOWS/ && $$3 ~/^\// && !seen[$$3]++ { print "cp", $$3, "./dist" }' | sh

.PHONY: 	all clean byte native clibs profile debug test
