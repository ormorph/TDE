# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

PYTHON_COMPAT=( python2_7 python3_6 )

inherit eutils flag-o-matic toolchain-funcs distutils-r1


DESCRIPTION="Python extension module generator for C and C++ libraries"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/dependencies/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

DEPEND="
	trinity-base/tdenv
	dev-qt/tqtinterface"
RDEPEND="${DEPEND}"

S="${WORKDIR}/dependencies/${PN}"

INCL="-I/usr/include/tqt -I/usr/tqt3/include "

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	mkdir ${S}/build_python2
	mkdir ${S}/build_python3
	cd ${S}/build_python2
	EPYTHON="python2.7" python ../configure.py
	sed "s#CFLAGS =#CFLAGS = $CFLAGS $INCL#" -i sipgen/Makefile
	sed "s#CXXFLAGS =#CXXFLAGS = $CFLAGS $INCL#" -i sipgen/Makefile
	sed "s#lib#$(get_libdir)#g" -i sipgen/Makefile
	sed 's#/../../../bin##g' -i sipgen/Makefile
	cd ${S}/build_python3
	EPYTHON="python3.6" python ../configure.py
	sed "s#CFLAGS = #CFLAGS = $CFLAGS $INCL#" -i sipgen/Makefile
	sed "s#CXXFLAGS =#CXXFLAGS = $CFLAGS $INCL#" -i sipgen/Makefile
	sed "s#lib#$(get_libdir)#g" -i sipgen/Makefile
	sed 's#/../../../bin##g' -i sipgen/Makefile
}

src_compile() {
	cd ${S}/build_python2
	emake
	cd ${S}/build_python3
	emake
}

src_install() {
	cd ${S}/build_python2
	emake install DESTDIR="${D}"
	cd ${S}/build_python3
	emake install DESTDIR="${D}"
	dobin ${FILESDIR}/sip
}
