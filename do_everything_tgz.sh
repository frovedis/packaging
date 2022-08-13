#!/bin/sh

# This script downloads required software, builds them,
# installs them and builds Frovedis for x86 and VE.
# Then crates rpm of Frovedis.
# You will be required to type passwords for sudo.

# We assume that there are downloaded Frovedis codes
# in ../x86 and ../ve, and boost-ve is in
# ../boost-ve

# We assume the OS is CentOS/RedHat7 or 8

set -eu

if [ $# != 1 ]; then
    echo "set first argument as prefix (e.g. if \"/foo\", \"/opt/nec\" is replaced by \"/foo\". It need to be absolute path"
    exit 1
fi

PREFIX=$1

set +e
echo ${PREFIX} | grep -q "^/"
if [ $? = 1 ]; then
    echo "prefix need to be absolute path"
    exit 1
fi
set -e

if [ ! -d ../x86 ] && [ ! -d ../ve ] && [ ! -d ../boost-ve ]; then
	echo "Place Frovedis in ../x86 and ../ve, and boost-ve in ../boost-ve"
	exit 1
else
	. /etc/os-release
	if [ $VERSION_ID = 7 ]; then
		sudo ./yum.sh
	else
		sudo ./yum8.sh
	fi
	./change_install_path_tgz.sh ${PREFIX}
	./build.sh
	sudo mkdir -p ${PREFIX}
	sudo ./install.sh
	set +u
	source ./x86env.sh
	set -u
	(cd ../x86; make; sudo make install)
	set +u
	source ./veenv.sh
	set -u
	(cd ../boost-ve; ./build.sh; sudo ./install.sh)
	cp Makefile.conf.ve ../ve/Makefile.conf
	(cd ../ve; make; sudo make install)
	VER=`grep VER= make_rpm.sh | sed s/VER=//`
	(cd ${PREFIX}; sudo tar -zcf /tmp/frovedis-${VER}-1.el${VERSION_ID}.tar.gz frovedis)
fi
