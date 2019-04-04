# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
inherit versionator multilib cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="Power management applet for Trinity"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="xscreensaver"

DEPEND="
	trinity-base/tde-common-cmake
	trinity-base/tdelibs
	trinity-base/tdebase
	dev-libs/dbus-tqt
	dev-libs/dbus-1-tqt
	x11-base/xorg-proto
	xscreensaver? ( x11-misc/xscreensaver )
	dev-util/cmake
	sys-devel/libtool
	app-misc/fdupes
	virtual/acl
	dev-util/desktop-file-utils
"
RDEPEND="$DEPEND"

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
	export PKG_CONFIG_PATH=:/opt/trinity/lib/pkgconfig
	mycmakeargs=(
	-DCMAKE_CXX_FLAGS="${CXXFLAGS} -std=c++11"
	-DCMAKE_INSTALL_PREFIX=${TDEDIR}
	-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
	-DCONFIG_INSTALL_DIR="/etc/trinity"
	-DBUILD_ALL=ON
	)

	 cmake-utils_src_configure
}
