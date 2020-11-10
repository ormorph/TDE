# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

inherit cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION=""
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
	virtual/pkgconfig
	sys-devel/libtool
	dev-util/desktop-file-utils
"
DEPEND="
	>=dev-qt/tqtinterface-${PV}
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
	cp -rf ${TDEDIR}/share/cmake .
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${TDEDIR}/$(get_libdir)/pkgconfig
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
	-DDATA_INSTALL_DIR="${TDEDIR}/share/apps"
	-DMIME_INSTALL_DIR="${TDEDIR}/share/mimelnk"
	-DXDG_APPS_INSTALL_DIR="${TDEDIR}/share/applications/tde"
	-DSHARE_INSTALL_PREFIX="${TDEDIR}/share"
	-DDOC_INSTALL_DIR=""${TDEDIR}/share/doc/tde""
	-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
	-DUSE_STRIGI=OFF
	-DUSE_MENUDRAKE=OFF
	-DBUILD_DOC=ON
	-DBUILD_ALL=ON
	)

	 cmake-utils_src_configure
}
