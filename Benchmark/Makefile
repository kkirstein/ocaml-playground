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
dist_sources = bin/benchmark.exe lwt_bin/lwt_benchmark.exe lwt_bin/lwt_pn_worker.exe lwt_bin/lwt_mb_worker.exe
dist_target = $(foreach f,$(dist_sources),./dist/$(basename $(notdir $(f)$(EXT_EXE))))
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

test: build
	jbuilder runtest

# make distribution package (folder)
dist: build
	rm -rf dist
	mkdir -p dist
	$(foreach f,$(dist_sources),cp _build/default/$(f) ./dist/$(basename $(notdir $(f)))$(EXT_EXE);)
	ldd $(dist_target) \
	 | awk '$$2  == "=>" && $$3 !~ /WINDOWS/ && $$3 ~/^\// && !seen[$$3]++ { print "cp", $$3, "./dist" }' | sh

.PHONY: 	all clean build test
