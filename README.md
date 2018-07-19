# Build tools for Frovedis

This directory contains tools for building and packaging Frovedis.
The scripts assumes that the platform is CentOS/RedHat 7.
If you do not change the install path, you can easily build it.

After the build, rpm file will be created in /tmp/rpmbuild/RPMS/x86_64/.
Please refer to getting_started.md that will be installed into 
${INSTALL} directory, which is /opt/nec/ve/nosupport/frovedis by default.

## Build all modules with one script

If you place Frovedis codes both in ../x86 and ../ve, and boost-ve 
in ../boost-ve, you can just execute ./do_everything.sh.
For example,

    $ git clone https://github.com/frovedis/frovedis x86
    $ git clone https://github.com/frovedis/frovedis ve
    $ git clone https://github.com/frovedis/boost-ve
    $ git clone https://github.com/frovedis/packaging
    $ cd packaging
    $ ./do_everything.sh

It downloads required software, builds them, installs them and
builds Frovedis for x86 and VE. Then it crates rpm of Frovedis.
(We assume versino 1.0.0 of NLC is installed on SX-Aurora TSUBASA.)

Internally sudo is used, so you might be required to type passwords for
sudo. Since it will take a long time to build, it would be better to
enable sudo without password, because sudo with password might timeout.

## Manual build

If you want to manually build and install, follow the steps below.

The script build.sh downloads packages for Spark build and execution
(Scala and Spark), and Open MPI for MPI implementation of x86. 

(We chose to build Open MPI manually, because rpm package installed
by yum might conflict with pre-installed Infiniband library on
SX-Aurora TSUBASA...)

After finishing build.sh, execute install.sh as root. It copies files
into install directory. If you want to change the install directory,
please change both x86env.sh and veenv.sh.

After that, please build Frovedis itself. You need to install the
packages listed in yum.sh. By sourcing ./x86env.sh you can use x86
version of mpic++, scalac, etc. that is installed in the previous
step. Do not forget to change install directory, etc. in the Makefiles
if you change it here.

Other than that, you do not have to change anything in the case of
x86. You can just type make; then type make install as root.

In the case of SX-Aurora TSUBASA, you need to change Makefile.conf 
as `TARGET := ve`. In addition, we recommend to change the
following settings, because BLAS, LAPACK and ScaLAPACK are in NLC.

    BUILD_BLAS := false
    BUILD_LAPACK := false
    BUILD_PARPACK := true
    BUILD_SCALAPACK := false

In this case, please confirm that the version of NLC is the same as
that of in Makefile.in.ve, which is used for linking path.
Currently, we assume the version is 1.0.0.
In the case of do_everything.sh script, this modificaiton is
automatically done.

In addition, in the case of SX-Aurora TSUBASA, you need to install
boost-ve separately. Please make sure the install path of the
boost can match the Makefile if you chanage the install path.

On SX-Aurora TSUBASA, we recommend to install both x86 and VE
version. To build both versions, it would be convenient to extract
Frovedis source code in separate directories.

After installing Frovedis, you can create rpm by calling make_rpm.sh.
It will be built in /tmp/rpmbuild/RPMS/x86_64/.
