# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_5,2_6,2_7} )

inherit cmake-utils python-single-r1

DESCRIPTION="Workload management system for compute-intensive jobs"
HOMEPAGE="http://www.cs.wisc.edu/htcondor/"
SRC_URI="condor_src-${PV}-all-all.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boinc cgroup contrib curl dmtcp doc kbdd kerberos libvirt management minimal postgres python soap ssl test xml"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="sys-libs/zlib
	>=dev-libs/libpcre-7.6
	>=dev-libs/boost-1.49.0[${PYTHON_USEDEP}]
	boinc? ( sci-misc/boinc )
	cgroup? ( >=dev-libs/libcgroup-0.37 )
	curl? ( >=net-misc/curl-7.19.7[ssl?] )
	dmtcp? ( sys-apps/dmtcp )
	libvirt? ( >=app-emulation/libvirt-0.6.2 )
	kerberos? ( virtual/krb5 )
	kbdd? ( x11-libs/libX11 )
	management? ( net-libs/qmf )
	postgres? ( >=dev-db/postgresql-base-8.2.4 )
	python? ( ${PYTHON_DEPS} )
	soap? ( >=net-libs/gsoap-2.7.11[ssl?] )
	ssl? ( >=dev-libs/openssl-0.9.8i )
	test? ( dev-util/valgrind )
	xml? ( >=dev-libs/libxml2-2.7.3 )"

RDEPEND="${DEPEND}
	mail-client/mailx"

RESTRICT=fetch

S="${WORKDIR}/condor-${PV}"

pkg_setup() {
	enewgroup condor
	enewuser condor -1 "${ROOT}"bin/bash "${ROOT}var/lib/condor" condor
}

src_configure() {
	# All the hard coded -DWITH_X=OFF flags are for packages that aren't in portage
	local mycmakeargs="
		-DCONDOR_PACKAGE_BUILD=OFF
		-DWITH_AVIARY=OFF
		-DWITH_BLAHP=OFF
		-DWITH_CAMPUSFACTORY=OFF
		-DWITH_CLUSTER_RA=OFF
		-DWITH_COREDUMPER=OFF
		-DWITH_CREAM=OFF
		-DWITH_GLOBUS=OFF
		-DWITH_LIBDELTACLOUD=OFF
		-DWITH_BLAHP=OFF
		-DWITH_QPID=OFF
		-DWITH_UNICOREGAHP=OFF
		-DWITH_VOMS=OFF
		-DWITH_WSO2=OFF
		$(cmake-utils_use_has boinc BACKFILL)
		$(cmake-utils_use_has boinc)
		$(cmake-utils_use_with cgroup LIBCGROUP)
		$(cmake-utils_use_want contrib)
		$(cmake-utils_use_with curl)
		$(cmake-utils_use_has dmtcp)
		$(cmake-utils_use_want doc MAN_PAGES)
		$(cmake-utils_use_with libvirt)
		$(cmake-utils_use_has kbdd)
		$(cmake-utils_use_with kerberos KRB5)
		$(cmake-utils_use_with postgres POSTGRESQL)
		$(cmake-utils_use_with python PYTHON_BINDINGS)
		$(cmake-utils_use_with management)
		$(cmake-utils_use minimal CLIPPED)
		$(cmake-utils_use_with soap GSOAP)
		$(cmake-utils_use_with ssl OPENSSL)
		$(cmake-utils_use_build test TESTING)
		$(cmake-utils_use_with xml LIBXML2)"
	cmake-utils_src_configure
}
