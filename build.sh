#!/bin/sh
set -eu

. ./x86env.sh
cd ./tgz
if [ ! -f openmpi-3.0.0.tar.gz ]; then
	wget `cat openmpi-3.0.0.tar.gz.URL`
fi
if [ ! -f scala-2.12.14.tgz ]; then
	wget `cat scala-2.12.14.tgz.URL`
fi
if [ ! -f spark-3.1.2-bin-hadoop3.2.tgz ]; then
	wget `cat spark-3.1.2-bin-hadoop3.2.tgz.URL`
fi
if [ ! -d ../build ]; then
	mkdir ../build
fi
cd ../build
tar -zxf ../tgz/openmpi-3.0.0.tar.gz
cd openmpi-3.0.0
./configure --prefix=${X86_INSTALLPATH}/opt/openmpi --without-verbs --without-ucx; make -j `/usr/bin/nproc`
