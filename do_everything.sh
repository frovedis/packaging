#!/bin/sh

# This script downloads required software, builds them,
# installs them and builds Frovedis for x86 and VE.
# Then crates rpm of Frovedis.
# You will be required to type passwords for sudo.

# We assume that there are downloaded Frovedis codes
# in ../x86 and ../ve, and boost-ve is in
# ../boost-ve

# We assume the OS is CentOS/RedHat7

set -eu

if [ ! -d ../x86 ] && [ ! -d ../ve ] && [ ! -d ../boost-ve ]; then
	echo "Place Frovedis in ../x86 and ../ve, and boost-ve in ../boost-ve"
	exit 1
else
	sudo ./yum.sh
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
	./make_rpm.sh
fi
