# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

inherit cmake-utils eutils desktop flag-o-matic gnome2-utils

DESCRIPTION="Dolphin focuses on being only a file manager"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

BDEPEND="
	dev-util/desktop-file-utils
	trinity-base/tde-common-cmake
"

DEPEND="
	trinity-base/tdelibs
	trinity-base/tdebase
"
RDEPEND="$DEPEND"

S="${WORKDIR}/${PN}-r${PV}"

TDEDIR="/opt/trinity"


src_prepare() {
	cp -rf ${TDEDIR}/share/cmake ${S}
	mycmakeargs=(
		-DWITH_BACKEND_LIBBFD=OFF
		-DWITH_BACKEND_READONLY=ON
)
	cmake-utils_src_prepare
}

src_configure() {
	cmake-utils_src_configure
}
