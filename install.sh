#!/bin/sh
# run as root

. ./x86env.sh
install -d ${X86_INSTALLPATH}/opt
install -d ${X86_INSTALLPATH}/opt/licenses
install -d ${X86_INSTALLPATH}/bin
install -d ${VE_INSTALLPATH}/bin
cd build/openmpi-3.0.0/; make install
cp LICENSE ${X86_INSTALLPATH}/opt/licenses/LICENSE.openmpi
cd ../../tgz
tar -zxf ${SCALA}.tgz -C ${X86_INSTALLPATH}/opt/ --no-same-owner
tar -zxf ${SPARK}.tgz -C ${X86_INSTALLPATH}/opt/ --no-same-owner
install -d ${X86_INSTALLPATH}/opt/zeppelin
cp ${ZEPPELIN}.tgz.URL ${X86_INSTALLPATH}/opt/zeppelin
cd ../
cp ./extract_zeppelin.sh ${X86_INSTALLPATH}/opt/zeppelin
cp ./*.json ${X86_INSTALLPATH}/opt/zeppelin
cp ./x86env.sh ${X86_INSTALLPATH}/bin
cp ./veenv.sh ${VE_INSTALLPATH}/bin
cp -r data ${INSTALLPATH}
cp getting_started.md ${INSTALLPATH}
