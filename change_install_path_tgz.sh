#!/bin/sh

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

sed s@INSTALLPATH=/opt/nec/frovedis@INSTALLPATH=${PREFIX}/frovedis@g -i x86env.sh
sed s@INSTALLPATH=/opt/nec/frovedis@INSTALLPATH=${PREFIX}/frovedis@g -i veenv.sh

cd ../boost-ve

sed s@INSTALLPATH=/opt/nec/frovedis/ve/opt/boost@INSTALLPATH=${PREFIX}/frovedis/ve/opt/boost@ -i build.sh

sed s@INSTALLPATH=/opt/nec/frovedis/ve/opt/boost@INSTALLPATH=${PREFIX}/frovedis/ve/opt/boost@ -i install.sh

cd ../x86

sed s@INSTALLPATH\ :=\ /opt/nec/frovedis/x86@INSTALLPATH\ :=\ ${PREFIX}/frovedis/x86@ -i Makefile.in.x86
sed s@INSTALLPATH\ :=\ /opt/nec/frovedis/x86@INSTALLPATH\ :=\ ${PREFIX}/frovedis/x86@ -i Makefile.in.icpc

sed s@BOOST_INC\ :=\ /opt/nec/frovedis/ve/opt/boost/include@BOOST_INC\ :=\ ${PREFIX}/frovedis/ve/opt/boost/include@g -i Makefile.in.ve
sed s@BOOST_LIB\ :=\ /opt/nec/frovedis/ve/opt/boost/lib@BOOST_LIB\ :=\ ${PREFIX}/frovedis/ve/opt/boost/lib@g -i Makefile.in.ve
sed s@INSTALLPATH\ :=\ /opt/nec/frovedis/ve@INSTALLPATH\ :=\ ${PREFIX}/frovedis/ve@ -i Makefile.in.ve

sed s@unmanagedBase\ :=\ file\(\"/opt/nec/frovedis/x86/lib/spark/\"\)@unmanagedBase\ :=\ file\(\"${PREFIX}/frovedis/x86/lib/spark/\"\)@ -i doc/tutorial_spark/src/build.sbt

cd ../ve

sed s@INSTALLPATH\ :=\ /opt/nec/frovedis/x86@INSTALLPATH\ :=\ ${PREFIX}/frovedis/x86@ -i Makefile.in.x86
sed s@INSTALLPATH\ :=\ /opt/nec/frovedis/x86@INSTALLPATH\ :=\ ${PREFIX}/frovedis/x86@ -i Makefile.in.icpc

sed s@BOOST_INC\ :=\ /opt/nec/frovedis/ve/opt/boost/include@BOOST_INC\ :=\ ${PREFIX}/frovedis/ve/opt/boost/include@g -i Makefile.in.ve
sed s@BOOST_LIB\ :=\ /opt/nec/frovedis/ve/opt/boost/lib@BOOST_LIB\ :=\ ${PREFIX}/frovedis/ve/opt/boost/lib@g -i Makefile.in.ve
sed s@INSTALLPATH\ :=\ /opt/nec/frovedis/ve@INSTALLPATH\ :=\ ${PREFIX}/frovedis/ve@ -i Makefile.in.ve

sed s@unmanagedBase\ :=\ file\(\"/opt/nec/frovedis/x86/lib/spark/\"\)@unmanagedBase\ :=\ file\(\"${PREFIX}/frovedis/x86/lib/spark/\"\)@ -i doc/tutorial_spark/src/build.sbt
