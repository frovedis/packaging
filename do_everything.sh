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
	./build.sh
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
	if [ $VERSION_ID -eq 7 ]; then
		./make_rpm.sh
	else
		./make_rpm8.sh
	fi
fi
