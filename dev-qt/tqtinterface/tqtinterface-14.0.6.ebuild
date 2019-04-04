# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="7"

inherit cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="Interface and abstraction library for Qt and Trinity"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+opengl"
SLOT="0"

DEPEND="
	trinity-base/tde-common-cmake
	dev-qt/tqt3
	opengl? ( dev-qt/tqt3[opengl] )
	dev-util/cmake
	virtual/pkgconfig
	sys-fs/e2fsprogs
	sys-apps/util-linux
	x11-base/xorg-server
	x11-libs/libXi
"

RDEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-r${PV}"

TQTBASE="/opt/trinity"
TDEDIR="${TQTBASE}"

src_configure() {
	cp -rf ${TDEDIR}/share/cmake .
	cp -rf ${TDEDIR}/share/cmake .
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/lib/pkgconfig:$PKG_CONFIG_PATH
	mycmakeargs=(
		-DQT_INCLUDE_DIR="${TQTBASE}/include"
		-DCMAKE_CXX_FLAGS="-LTQTBASE/$(get_libdir)"
		-DQT_PREFIX_DIR="${TQTBASE}"
		-DQT_LIBRARY_DIR="${TQTBASE}/$(get_libdir)"
		-DQT_VERSION=3
		-DBUILD_ALL=ON
	)

	 cmake-utils_src_configure
}
