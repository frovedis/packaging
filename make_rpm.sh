#!/bin/sh
set -eu

# https://stackoverflow.com/questions/880227/what-is-the-minimum-i-have-to-do-to-create-an-rpm-file
# http://dev.tapweb.co.jp/2010/12/273

. ./x86env.sh

VER=1.1.1
PKG=frovedis-${VER}

rm -fr /tmp/rpmbuild
mkdir -p /tmp/rpmbuild/{RPMS,SRPMS,BUILD,SOURCES,SPECS,tmp}

cat <<EOF >~/.rpmmacros
%_topdir   %(echo /tmp)/rpmbuild
%_tmppath  %{_topdir}/tmp
EOF

cd /tmp/rpmbuild

mkdir ${PKG}
install -d ${PKG}${INSTALLPATH}
cp -r ${INSTALLPATH} ${PKG}${INSTALLPATH}/..
tar -zcf ${PKG}.tar.gz ${PKG}

cp ${PKG}.tar.gz SOURCES/
cat <<EOF > SPECS/frovedis.spec
Autoreq: 0 

# Don't try fancy stuff like debuginfo, which is useless on binary-only
# packages. Don't strip binary too
# Be sure buildpolicy set to do nothing
%define        __spec_install_post %{nil}
%define          debug_package %{nil}
%define        __os_install_post %{_dbpath}/brp-compress

Summary: Framework of vectorized and distributed data analytics
Name: frovedis
Version: ${VER}
Release: 1.el7
License: BSD
Group: Development/Tools
SOURCE0 : %{name}-%{version}.tar.gz
URL: http://www.nec.com/
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
Requires: boost-devel
Requires: gcc
Requires: gcc-c++
Requires: gcc-gfortran
Requires: java-1.8.0-openjdk-devel
Requires: python-devel
Requires: python-pandas
Requires: scipy
Requires: python2-funcsigs
Requires: python2-pip
Requires: python-virtualenv
Requires: numactl-devel

%description
%{summary}

%prep
%setup -q

%build
# Empty section.

%install
rm -rf %{buildroot}
mkdir -p  %{buildroot}

# in builddir
cp -a * %{buildroot}

%clean
rm -rf %{buildroot}

%changelog

%files
%defattr(-,root,root,-)
EOF

find ${INSTALLPATH} -type f -or -type l >> SPECS/frovedis.spec
find ${INSTALLPATH} -type d | sed -e "s/^/%dir /" >> SPECS/frovedis.spec

rpmbuild -ba SPECS/frovedis.spec
