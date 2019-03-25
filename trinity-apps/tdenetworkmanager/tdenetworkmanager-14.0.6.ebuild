# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator multilib cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="TDE applet for NetworkManager"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="
	trinity-base/tde-common-cmake
	dev-qt/tqtinterface
	trinity-base/tdelibs
	dev-util/cmake
        dev-util/desktop-file-utils
        sys-devel/libtool
        virtual/pkgconfig
	sys-devel/gettext
	app-misc/fdupes
	dev-libs/dbus-1-tqt
	dev-libs/dbus-tqt
	virtual/udev
	net-dns/libidn
        app-admin/gamin
	dev-libs/openssl
	virtual/acl
"
RDEPEND="$DEPEND"

S="${WORKDIR}/${PN}-r${PV}"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

src_configure() {
	cp -rf ${TDEDIR}/share/cmake ${S}/
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/lib/pkgconfig
	mycmakeargs=(
	-DCMAKE_BUILD_TYPE="RelWithDebInfo"
	-DCMAKE_INSTALL_PREFIX=${TDEDIR}
	-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
	-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
	-DCMAKE_SKIP_RPATH=OFF
	-DCMAKE_INSTALL_RPATH="${TDEDIR}/$(get_libdir)"
	-DCMAKE_VERBOSE_MAKEFILE=ON
	-DWITH_GCC_VISIBILITY=OFF
	-DINCLUDE_INSTALL_DIR="${TDEDIR}/include"
	-DSHARE_INSTALL_PREFIX="${TDEDIR}/share"
	-DDOC_INSTALL_DIR=""${TDEDIR}/share/doc/tde""
	-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
	)

	 cmake-utils_src_configure
}
