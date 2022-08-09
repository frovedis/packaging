#!/bin/sh

set -eu

NEWPATH='~'

# ${NEWPATH} will be appended to the head of the installation path

sed s@INSTALLPATH=/opt/nec/frovedis@INSTALLPATH=${NEWPATH}/opt/nec/frovedis@g -i x86env.sh
sed s@INSTALLPATH=/opt/nec/frovedis@INSTALLPATH=${NEWPATH}/opt/nec/frovedis@g -i veenv.sh

cd ../boost-ve

sed s@INSTALLPATH=/opt/nec/frovedis/ve/opt/boost@INSTALLPATH=${NEWPATH}/opt/nec/frovedis/ve/opt/boost@ -i build.sh

sed s@INSTALLPATH=/opt/nec/frovedis/ve/opt/boost@INSTALLPATH=${NEWPATH}/opt/nec/frovedis/ve/opt/boost@ -i install.sh

cd ../x86

sed s@INSTALLPATH\ :=\ /opt/nec/frovedis/x86@INSTALLPATH\ :=\ ${NEWPATH}/opt/nec/frovedis/x86@ -i Makefile.in.x86
sed s@INSTALLPATH\ :=\ /opt/nec/frovedis/x86@INSTALLPATH\ :=\ ${NEWPATH}/opt/nec/frovedis/x86@ -i Makefile.in.icpc

sed s@BOOST_INC\ :=\ /opt/nec/frovedis/ve/opt/boost/include@BOOST_INC\ :=\ ${NEWPATH}/opt/nec/frovedis/ve/opt/boost/include@g -i Makefile.in.ve
sed s@BOOST_LIB\ :=\ /opt/nec/frovedis/ve/opt/boost/lib@BOOST_LIB\ :=\ ${NEWPATH}/opt/nec/frovedis/ve/opt/boost/lib@g -i Makefile.in.ve
sed s@INSTALLPATH\ :=\ /opt/nec/frovedis/ve@INSTALLPATH\ :=\ ${NEWPATH}/opt/nec/frovedis/ve@ -i Makefile.in.ve

sed s@-I\${BOOST_INC}@-I\ \${BOOST_INC}@ -i Makefile.in.ve
sed s@-L\${BOOST_LIB}@-L\ \${BOOST_LIB}@ -i Makefile.in.ve

for file in doc/tutorial/src/Makefile.each.x86 doc/tutorial/src/Makefile.each.ve doc/tutorial/src/Makefile.each.icpc doc/tutorial/src/Makefile.each.omp.x86 doc/tutorial/src/Makefile.each.omp.ve doc/tutorial/src/Makefile.each.omp.icpc samples/Makefile.common; do
    sed s@-I\${INSTALLPATH}/include@-I\ \${INSTALLPATH}/include@ -i $file
    sed s@-L\${INSTALLPATH}/lib@-L\ \${INSTALLPATH}/lib@ -i $file
done

sed s@unmanagedBase\ :=\ file\(\"/opt/nec/frovedis/x86/lib/spark/\"\)@unmanagedBase\ :=\ file\(sys.props.getOrElse\(\"HOME\",\"\"\)\ +\ \"/opt/nec/frovedis/x86/lib/spark/\"\)@ -i doc/tutorial_spark/src/build.sbt

cd ../ve

sed s@INSTALLPATH\ :=\ /opt/nec/frovedis/x86@INSTALLPATH\ :=\ ${NEWPATH}/opt/nec/frovedis/x86@ -i Makefile.in.x86
sed s@INSTALLPATH\ :=\ /opt/nec/frovedis/x86@INSTALLPATH\ :=\ ${NEWPATH}/opt/nec/frovedis/x86@ -i Makefile.in.icpc

sed s@BOOST_INC\ :=\ /opt/nec/frovedis/ve/opt/boost/include@BOOST_INC\ :=\ ${NEWPATH}/opt/nec/frovedis/ve/opt/boost/include@g -i Makefile.in.ve
sed s@BOOST_LIB\ :=\ /opt/nec/frovedis/ve/opt/boost/lib@BOOST_LIB\ :=\ ${NEWPATH}/opt/nec/frovedis/ve/opt/boost/lib@g -i Makefile.in.ve
sed s@INSTALLPATH\ :=\ /opt/nec/frovedis/ve@INSTALLPATH\ :=\ ${NEWPATH}/opt/nec/frovedis/ve@ -i Makefile.in.ve

sed s@-I\${BOOST_INC}@-I\ \${BOOST_INC}@ -i Makefile.in.ve
sed s@-L\${BOOST_LIB}@-L\ \${BOOST_LIB}@ -i Makefile.in.ve

for file in doc/tutorial/src/Makefile.each.x86 doc/tutorial/src/Makefile.each.ve doc/tutorial/src/Makefile.each.icpc doc/tutorial/src/Makefile.each.omp.x86 doc/tutorial/src/Makefile.each.omp.ve doc/tutorial/src/Makefile.each.omp.icpc samples/Makefile.common; do
    sed s@-I\${INSTALLPATH}/include@-I\ \${INSTALLPATH}/include@ -i $file
    sed s@-L\${INSTALLPATH}/lib@-L\ \${INSTALLPATH}/lib@ -i $file
done

sed s@unmanagedBase\ :=\ file\(\"/opt/nec/frovedis/x86/lib/spark/\"\)@unmanagedBase\ :=\ file\(sys.props.getOrElse\(\"HOME\",\"\"\)\ +\ \"/opt/nec/frovedis/x86/lib/spark/\"\)@ -i doc/tutorial_spark/src/build.sbt
