#!/bin/sh
set -eu

if [ $# -eq 1 ]; then
	if [ -z "${X86_INSTALLPATH}" ] || [ -z "${ZEPPELIN}" ] ; then
		echo "Please source x86env.sh to set environment variables"
	else
		if [ -f $1 ]; then
			echo "specified argument is file, not directory"
			exit
		fi
		if [ ! -d $1 ]; then
			mkdir $1
		fi
		wget `cat ${X86_INSTALLPATH}/opt/zeppelin/${ZEPPELIN}.tgz.URL`
		if [ $? = 0 ]; then
			tar -zxf ${ZEPPELIN}.tgz -C $1
			rm ${ZEPPELIN}.tgz
			cp -f ${X86_INSTALLPATH}/opt/zeppelin/*.json $1
		else
			echo "failed to wget zepppelin binary. check your environment (e.g. http proxy)"
		fi
	fi
else
	echo $#
	echo "$0 directory_to_extract"
fi
		
