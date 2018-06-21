#!/bin/sh

. ./x86env.sh
cd ./tgz
wget `cat openmpi-3.0.0.tar.gz.URL`
wget `cat scala-2.11.12.tgz.URL`
wget `cat spark-2.2.1-bin-hadoop2.7.tgz.URL`
cd ../build
tar -zxf ../tgz/openmpi-3.0.0.tar.gz
cd openmpi-3.0.0
./configure --prefix=${X86_INSTALLPATH}/opt/openmpi; make
