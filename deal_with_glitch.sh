#!/bin/sh
# modify files to deal with the glitch of nc++ 5.2.0
# run before do_everything.sh

set -eu

sed s@-O3\ \;@-O3\ -fcheck-noexcept-violation\ -fno-cse-after-vectorization\ \;@g -i ../boost-ve/modified/tools/build/src/tools/ncc.jam

sed s@-finline-max-function-size=200\ -Wno-unknown-pragma@-finline-max-function-size=200\ -fcheck-noexcept-violation\ -fno-cse-after-vectorization\ -Wno-unknown-pragma@g -i ../ve/Makefile.in.ve

sed 452s@\#if\ defined\(__GNUC__\)\ \|\|\ defined\(__clang__\)@\#if\ 0@g -i ../ve/third_party/cereal-1.2.2/include/cereal/external/rapidjson/rapidjson.h
sed 465s@\#if\ defined\(__GNUC__\)\ \|\|\ defined\(__clang__\)@\#if\ 0@g -i ../ve/third_party/cereal-1.2.2/include/cereal/external/rapidjson/rapidjson.h
