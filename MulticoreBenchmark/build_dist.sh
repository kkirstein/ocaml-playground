#! /usr/bin/env sh

# platform dependent settings
UNAME_O=`uname -o`
if [ ${UNAME_O} = Cygwin ]
then
	EXT_EXE=.exe
else
	EXT_EXE=
fi

targets="benchmark"
#dist_target=./dist/benchmark${EXT_EXE}
dist_folder=./dist

dune build

rm -rf dist
mkdir -p dist
for t in ${targets}
do
	file_target=${dist_folder}/${t}${EXT_EXE}
	cp _build/default/bin/${t}.exe ${file_target}

	if [ ${UNAME_O} = Cygwin ]
	then
		ldd ${file_target} \
			| awk '$2  == "=>" && $3 !~ /WINDOWS/ && $3 ~/^\// && !seen[$3]++ { print "cp", $3, "./dist" }' \
			| sh
	fi
done
