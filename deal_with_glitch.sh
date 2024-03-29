#!/bin/sh
# modify files to deal with the glitch of nc++ 5.2.0

set -eu

sed s@-finline-max-function-size=200\ -Wno-unknown-pragma@-finline-max-function-size=200\ -fno-cse-after-vectorization\ -Wno-unknown-pragma@g -i ../ve/Makefile.in.ve

sed 452s@\#if\ defined\(__GNUC__\)\ \|\|\ defined\(__clang__\)@\#if\ 0@g -i ../ve/third_party/cereal-1.2.2/include/cereal/external/rapidjson/rapidjson.h
sed 465s@\#if\ defined\(__GNUC__\)\ \|\|\ defined\(__clang__\)@\#if\ 0@g -i ../ve/third_party/cereal-1.2.2/include/cereal/external/rapidjson/rapidjson.h
