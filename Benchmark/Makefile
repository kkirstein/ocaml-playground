#
# Makefile for Machine Learning tools
#

# platform dependent settings
UNAME_O = $(shell uname -o)
ifeq ($(UNAME_O), Cygwin)
	EXT_EXE = .exe
else
	EXT_EXE =
endif

# targets for distribution
main_lwt = lwt_benchmark
main = benchmark
main_test = test_runner
worker = lwt_pn_worker
test_sources = lib/color_map.ml lib/fibonacci.ml \
	lib/image.ml lib/mandelbrot.ml lib/perfect_number.ml
clib = perfect_number_stubs

all: build

clean:
	jbuilder clean

distclean: clean
	rm -rf dist

build:
	jbuilder build

run: build
	_build/default/bin/$(main).exe

run_async: build
	_build/default/lwt_bin/$(main_lwt).exe

# iTeML tests
$(main_test).ml: $(test_sources)
	qtest -o ./bin/$@ extract $^

test: clibs $(main_test).ml
	$(OCB) $(main_test).native $(OCB_FLAGS_TEST)
	_build/bin/$(main_test).native

# make distribution package (folder)
dist: build
	rm -rf dist
	mkdir -p dist
	cp _build/default/bin/$(main).exe ./dist/$(main)$(EXT_EXE)
	cp _build/default/lwt_bin/$(main_lwt).exe ./dist/$(main_lwt)$(EXT_EXE)
	cp _build/default/lwt_bin/$(worker).exe ./dist/$(worker)$(EXT_EXE)
	ldd ./dist/$(main)$(EXT_EXE) ./dist/$(main_lwt)$(EXT_EXE) ./dist/$(worker)$(EXT_EXE) \
	 | awk '$$2  == "=>" && $$3 !~ /WINDOWS/ && $$3 ~/^\// && !seen[$$3]++ { print "cp", $$3, "./dist" }' | sh

.PHONY: 	all clean build test
