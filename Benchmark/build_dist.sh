#! /usr/bin/env sh

# platform dependent settings
UNAME_O=`uname -o`
if [ ${UNAME_O} = Cygwin ]
then
	EXT_EXE=.exe
else
	EXT_EXE=
fi

dist_target=./dist/benchmark${EXT_EXE}

dune build

rm -rf dist
mkdir -p dist
cp _build/default/bin/benchmark.exe ${dist_target}

if [ ${UNAME_O} = Cagwin ]
then
	ldd ${dist_target} \
		| awk '$2  == "=>" && $3 !~ /WINDOWS/ && $3 ~/^\// && !seen[$3]++ { print "cp", $3, "./dist" }' \
		| sh
fi

