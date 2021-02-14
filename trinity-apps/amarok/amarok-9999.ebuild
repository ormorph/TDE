# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

inherit cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="Advanced audio player based on KDE frameworks"
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
IUSE="+xine visual "

BDEPEND="
	trinity-base/tde-common-cmake
"
DEPEND="
	sys-apps/dbus
	>=dev-qt/tqtinterface-${PV}
	~trinity-base/tdelibs-${PV}
	xine? ( media-libs/xine-lib )
	visual? ( media-libs/libvisual )
	dev-db/sqlite:3
	media-libs/libmp4v2
	media-libs/taglib
"
RDEPEND="$DEPEND"

if [[ ${PV} = 14.0.999 ]] || [[ ${PV} = 9999 ]]; then
	S="${WORKDIR}/${P}"
else
	S="${WORKDIR}/${PN}-r${PV}"
fi

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

src_configure() {
	cp -rf ${TDEDIR}/share/cmake ${S}/
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${TDEDIR}/$(get_libdir)/pkgconfig
	mycmakeargs=(
	-DCMAKE_INSTALL_PREFIX=${TDEDIR}
	-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
	-DWITH_XINE=$(usex xine)
	-DWITH_LIBVISUAL=$(usex visual)
	-DWITH_SYSTEM_SQLITE=ON
	-DWITH_MP4V2=ON
	-DBUILD_ALL=ON
#	-DWITH_DAAP=ON
	)

	 cmake-utils_src_configure
}
