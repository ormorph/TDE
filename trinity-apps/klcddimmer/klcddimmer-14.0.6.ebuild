# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

inherit cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="Applet to adjust LCD brightness for TDE"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

BDEPEND="
	trinity-base/tde-common-cmake
	dev-util/desktop-file-utils
	virtual/pkgconfig
"
DEPEND="
	trinity-base/tdelibs
	trinity-base/tdebase
	virtual/acl
	net-dns/libidn
	dev-libs/openssl
"
RDEPEND="$DEPEND"

S="${WORKDIR}/${PN}-r${PV}"

TDEDIR="/opt/trinity"


src_configure() {
	cp -rf ${TDEDIR}/share/cmake .
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/$(get_libdir)/pkgconfig
	export QTDIR=$TQT
	mycmakeargs=(
		-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
		-DCMAKE_SKIP_RPATH=OFF
		-DCMAKE_INSTALL_RPATH="${TDEDIR}/$(get_libdir)"
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCMAKE_PROGRAM_PATH="${TDEDIR}/bin"
		-DWITH_GCC_VISIBILITY=OFF
		-DCMAKE_INSTALL_PREFIX=${TDEDIR}
		-DBIN_INSTALL_DIR="${TDEDIR}/bin"
		-DCONFIG_INSTALL_DIR="/etc/trinity"
		-DINCLUDE_INSTALL_DIR="${TDEDIR}/include"
		-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
		-DSHARE_INSTALL_PREFIX="${TDEDIR}/share"
		-DWITH_ALL_OPTIONS=ON
		-DBUILD_DOC=ON
		-DBUILD_TRANSLATIONS=ON
		-DBUILD_ALL=ON
)
	cmake-utils_src_configure
}
