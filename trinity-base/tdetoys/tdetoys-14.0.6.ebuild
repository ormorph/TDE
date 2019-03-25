# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"


inherit versionator multilib cmake-utils desktop flag-o-matic gnome2-utils


DESCRIPTION="Tux screensaver for Trinity"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="xscreensaver klaptopdaemon"
SLOT="0"

DEPEND="
	trinity-base/tde-common-cmake
	trinity-base/tdelibs
	trinity-base/tdebase[xscreensaver]
	dev-libs/glib:2
	sys-devel/gettext
	dev-util/cmake
	virtual/pkgconfig
	app-misc/fdupes
	dev-util/desktop-file-utils
	net-dns/libidn
	app-admin/gamin
	virtual/acl
	dev-libs/libpcre
	dev-libs/openssl
"
RDEPEND="${RDEPEND}"

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
	cp -rf ${TDEDIR}/share/cmake ${S}/
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/$(get_libdir)/pkgconfig
	export QTDIR=$TQT
	export LIBDIR=/opt/trinity/lib
	mycmakeargs=(
#		-DCMAKE_CXX_FLAGS="-L${TQT}/lib"
		-DCMAKE_INSTALL_PREFIX=${TDEDIR}

		-DCMAKE_BUILD_TYPE="RelWithDebInfo"
		-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
		-DCMAKE_CXX_FLAGS="${CSSFLAGS} -DNDEBUG"
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
		-DBUILD_ALL=ON
	)

	cmake-utils_src_configure
}

#src_install() {
#	cmake-utils_src_install
#
#}

