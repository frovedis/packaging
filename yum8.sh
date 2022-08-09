#!/bin/sh

# required for pandas; if installed return error so do not set -e
# yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

set -eu
# make it dependent
yum install boost-devel
yum install gcc gcc-c++ gcc-gfortran
yum install java-1.8.0-openjdk-devel.x86_64
yum install python36-devel.x86_64
# yum install python3-pandas.x86_64 #can't install
yum install python3-scipy.x86_64
yum install python3-pip
# for OpenMPI
yum install numactl-devel
