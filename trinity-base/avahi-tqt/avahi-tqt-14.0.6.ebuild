# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

inherit cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="Avahi Multicast DNS Responder (TQT Support)."
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="
	trinity-base/tde-common-cmake
	sys-apps/dbus
	dev-util/cmake
	trinity-base/tde-common-cmake
	dev-qt/tqtinterface
	virtual/pkgconfig
	sys-devel/libtool
	dev-libs/glib:2
	sys-devel/gettext
	x11-base/xorg-server
	x11-libs/libXi
	dev-libs/dbus-1-tqt
	dev-libs/dbus-tqt
	sys-libs/libcap
	net-dns/avahi
	dev-libs/expat
	media-libs/nas
	x11-libs/libXt"
RDEPEND="$DEPEND"

S="${WORKDIR}/${PN}-r${PV}"

TQT="/usr/tqt3"
TDEDIR="/opt/trinity"

src_configure() {
	cp -rf ${TDEDIR}/share/cmake ${S}/
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	mycmakeargs=(
	-DQT_INCLUDE_DIR="${TQT}/include"
	-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
	-DCMAKE_CXX_FLAGS="${CXXFLAGS} -L${TQT}/lib -DNDEBUG"
	-DCMAKE_INSTALL_PREFIX=${TDEDIR}
	-DCMAKE_SKIP_RPATH=ON
	-DCMAKE_VERBOSE_MAKEFILE=ON
	-DWITH_GCC_VISIBILITY=OFF
	)

	 cmake-utils_src_configure
}
