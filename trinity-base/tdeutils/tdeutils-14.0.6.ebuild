# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"


inherit cmake-utils desktop flag-o-matic gnome2-utils


DESCRIPTION="Utilities for the Trinity Desktop Environment, including"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="xscreensaver klaptopdaemon"
SLOT="0"

DEPEND="
	trinity-base/tde-common-cmake
	dev-qt/tqtinterface
	trinity-base/tdelibs
	trinity-base/tdebase
	dev-libs/glib:2
	sys-devel/gettext
	dev-util/cmake
	virtual/pkgconfig
	app-misc/fdupes
	net-analyzer/net-snmp
	dev-lang/python
	dev-libs/gmp
	dev-util/desktop-file-utils
	x11-libs/libXtst
	app-admin/gamin
	dev-libs/libpcre
	virtual/acl
	xscreensaver? ( x11-libs/libXScrnSaver )
	dev-libs/openssl
	app-arch/unzip
	app-arch/zip
	app-arch/bzip2
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-r${PV}"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

pkg_setup() {
	if [[ "$ARCH" == "amd64" ]]; then
		export LIBDIRSUFFIX="64"
	else
		export LIBDIRSUFFIX=""
	fi
}

src_configure() {
	cp -rf ${TDEDIR}/share/cmake .
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/$(get_libdir)/pkgconfig
	export QTDIR=$TQT
	export LIBDIR=/opt/trinity/lib
	mycmakeargs=(
#		-DCMAKE_CXX_FLAGS="-L${TQT}/lib"
		-DCMAKE_INSTALL_PREFIX=${TDEDIR}

		-DCMAKE_BUILD_TYPE="RelWithDebInfo"
		-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
		-DCMAKE_SKIP_RPATH=OFF
		-DCMAKE_INSTALL_RPATH="${TDEDIR}/$(get_libdir)"
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DWITH_GCC_VISIBILITY=OFF

		-DBIN_INSTALL_DIR="${TDEDIR}/bin"
		-DCONFIG_INSTALL_DIR="/etc/trinity"
		-DDOC_INSTALL_DIR="/usr/share/doc"
		-DINCLUDE_INSTALL_DIR="${TDEDIR}/include"
		-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
		-DPKGCONFIG_INSTALL_DIR="${TDEDIR}/$(get_libdir)/pkgconfig"
		-DSHARE_INSTALL_PREFIX="${TDEDIR}/share"

		-DWITH_DPMS=ON
		-DWITH_XSCREENSAVER=$(usex xscreensaver)
		-DWITH_ASUS=ON
		-DWITH_POWERBOOK=OFF
		-DWITH_POWERBOOK2=OFF
		-DWITH_VAIO=ON
		-DWITH_THINKPAD=ON
		-DWITH_I8K=ON
		-DWITH_SNMP=ON
		-DWITH_SENSORS=ON
		-DWITH_XMMS=ON
		-DWITH_TDENEWSTUFF=ON
		-DBUILD_ALL=ON
		-DBUILD_KLAPTOPDAEMON=$(usex klaptopdaemon)
	)

	cmake-utils_src_configure
}

#src_install() {
#	cmake-utils_src_install
#
#}

