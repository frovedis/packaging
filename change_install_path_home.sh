#!/bin/sh

set -eu

NEWPATH='~'

# ${NEWPATH} will be appended to the head of the installation path

sed s@INSTALLPATH=/opt/nec/frovedis@INSTALLPATH=${NEWPATH}/opt/nec/frovedis@g -i x86env.sh

set +e
grep -q "/tmp/opt/openmpi" x86env.sh
if [ $? = 1 ]; then
    sed s@path_prepend\ \$\{X86_INSTALLPATH\}/opt/openmpi/bin@path_prepend\ /tmp/opt/openmpi/bin@ -i x86env.sh
    echo 'if [ -h /tmp/opt/openmpi ]; then if [ ! -r /tmp/opt/openmpi ]; then echo "/tmp/opt/openmpi is conflicting; other user might be using Frovedis" ; fi; else mkdir /tmp/opt; ln -s ${X86_INSTALLPATH}/opt/openmpi /tmp/opt; fi' >> x86env.sh
fi
set -e

sed s@INSTALLPATH=/opt/nec/frovedis@INSTALLPATH=${NEWPATH}/opt/nec/frovedis@g -i veenv.sh

set +e
grep -q "/tmp/opt/openmpi" veenv.sh
if [ $? = 1 ]; then
    sed s@path_remove\ \$\{X86_INSTALLPATH\}/opt/openmpi/bin@path_remove\ /tmp/opt/openmpi/bin@ -i veenv.sh
    echo 'if [ -h /tmp/opt/openmpi ]; then if [ ! -r /tmp/opt/openmpi ]; then echo "/tmp/opt/openmpi is conflicting; other user might be using Frovedis" ; fi; else mkdir /tmp/opt; ln -s ${X86_INSTALLPATH}/opt/openmpi /tmp/opt; fi' >> veenv.sh
fi
set -e


# change OpenMPI installation path to /tmp, since it need to be absolute
sed s@'${X86_INSTALLPATH}/opt/openmpi'@/tmp/opt/openmpi@ -i build.sh

set +e
grep -q "/tmp/opt" install.sh
if [ $? = 1 ]; then
    sed s@cd\ build/openmpi-3\.0\.0/\;\ make\ install@'mkdir\ /tmp/opt\;\ mkdir\ -p\ ${X86_INSTALLPATH}/opt/openmpi\;\ ln\ -s\ ${X86_INSTALLPATH}/opt/openmpi\ /tmp/opt\;\ cd\ build/openmpi\-3\.0\.0/\;\ make install'@ -i install.sh
fi
set -e

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
