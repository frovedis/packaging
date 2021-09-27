#!/bin/sh

path_append ()  { path_remove $1; export PATH="$PATH:$1"; }
path_prepend () { path_remove $1; export PATH="$1:$PATH"; }
path_remove ()  { export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }

ldpath_append ()  { ldpath_remove $1; export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$1"; }
ldpath_prepend () { ldpath_remove $1; export LD_LIBRARY_PATH="$1:$LD_LIBRARY_PATH"; }
ldpath_remove ()  { export LD_LIBRARY_PATH=`echo -n $LD_LIBRARY_PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }

manpath_append ()  { manpath_remove $1; export MANPATH="$MANPATH:$1"; }
manpath_prepend () { manpath_remove $1; export MANPATH="$1:$MANPATH"; }
manpath_remove ()  { export MANPATH=`echo -n $MANPATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }

if [ -z "$NMPI_ROOT" ]; then
	MPIVAR=`ls /opt/nec/ve/mpi | grep ^[0-9] | sort -V -r | head -1`
	source /opt/nec/ve/mpi/${MPIVAR}/bin/necmpivars.sh
fi
export INSTALLPATH=/opt/nec/frovedis
export X86_INSTALLPATH=${INSTALLPATH}/x86
export VE_INSTALLPATH=${INSTALLPATH}/ve
export FROVEDIS_SERVER=${VE_INSTALLPATH}/bin/frovedis_server
SCALA=scala-2.12.14
SPARK=spark-3.1.2-bin-hadoop3.2
export ZEPPELIN=zeppelin-0.9.0-bin-netinst
path_remove ${X86_INSTALLPATH}/opt/openmpi/bin
path_append ${X86_INSTALLPATH}/opt/${SCALA}/bin
path_append ${X86_INSTALLPATH}/opt/${SPARK}/bin
path_append ${X86_INSTALLPATH}/opt/${SPARK}/sbin
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
export SCALA_HOME=${X86_INSTALLPATH}/opt/${SCALA}
export SPARK_HOME=${X86_INSTALLPATH}/opt/${SPARK}
export SPARK_SUBMIT_OPTIONS="--driver-java-options \"-Djava.library.path=${X86_INSTALLPATH}/lib\" --jars ${X86_INSTALLPATH}/lib/spark/frovedis_client.jar --conf spark.driver.memory=8g"
export PYTHONPATH=${X86_INSTALLPATH}/lib/python
ldpath_append ${X86_INSTALLPATH}/lib
export MANPATH=`manpath -q`
manpath_append ${VE_INSTALLPATH}/man
export FROVEDIS_SEQUENTIAL_SAVE=true # for NFS that doesn't support multi writer
export VE_LD_PRELOAD=libveaccio.so.1
export VE_OMP_NUM_THREADS=1 # needed for frovedis_server; otherwise it stucks!
