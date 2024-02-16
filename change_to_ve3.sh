#!/bin/sh

set -eu

sed s@/opt/nec/ve/mpi@/opt/nec/ve3/mpi@g -i veenv.sh
sed s@/opt/nec/ve/nlc/@/opt/nec/ve3/nlc/@g -i ../ve/Makefile.in.ve
sed s@nas@nas\ -march=ve3@g -i ../ve/src/frovedis/ml/Makefile.ve
