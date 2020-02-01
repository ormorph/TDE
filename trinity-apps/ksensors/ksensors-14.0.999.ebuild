# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

inherit cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="Ksensors is a nice lm-sensors frontend for the K Desktop Environment"
HOMEPAGE="http://trinitydesktop.org/"

if [[ ${PV} = 14.0.999 ]]; then
	inherit git-r3
        EGIT_REPO_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}"
        EGIT_BRANCH="r14.0.x"
	EGIT_SUBMODULES=()
elif [[ ${PV} = 9999 ]]; then
	inherit git-r3
        EGIT_REPO_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}"
	EGIT_SUBMODULES=()
else
	SRC_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"
fi

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

BDEPEND="
	trinity-base/tde-common-cmake
"

DEPEND="
	>=trinity-base/tdelibs-${PV}
	>=trinity-base/tdebase-${PV}
	dev-util/desktop-file-utils
	virtual/pkgconfig
	app-misc/fdupes
	sys-devel/autoconf
        sys-devel/gettext
        sys-devel/automake
        sys-devel/libtool
        sys-devel/m4
	|| ( sys-apps/lm_sensors
	sys-apps/lm-sensors )
"
RDEPEND="$DEPEND"

if [[ ${PV} = 14.0.999 ]] || [[ ${PV} = 9999 ]]; then
	S="${WORKDIR}/${P}"
else
	S="${WORKDIR}/${PN}-r${PV}"
fi

TDEDIR="/opt/trinity"


src_prepare() {
	cp -rf ${TDEDIR}/share/cmake .
	cmake-utils_src_prepare
}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/lib/pkgconfig
	mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=${TDEDIR}
		-DWITH_GCC_VISIBILITY=OFF
		-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)")
	cmake-utils_src_configure

}
