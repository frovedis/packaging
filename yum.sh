#!/bin/sh

# required for pandas; if installed return error so do not set -e
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

set -eu
# make it dependent
yum install boost-devel
yum install gcc gcc-c++ gcc-gfortran
yum install java-1.8.0-openjdk-devel.x86_64
yum install python-devel.x86_64
yum install python-pandas.x86_64
#yum install blas.x86_64
#yum install lapack.x86_64
yum install scipy.x86_64
yum install python2-pip
yum install python-virtualenv
# for OpenMPI
yum install numactl-devel
