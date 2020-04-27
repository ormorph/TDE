# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

inherit cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="Trinity Desktop Environment - Plugins"
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

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="-noatun -arts -atlantikdesigner kicker kaddressbook"

BDEPEND="
	trinity-base/tde-common-cmake
	virtual/pkgconfig
	app-misc/fdupes
"
DEPEND="
	>=trinity-base/tdebase-${PV}
	>=trinity-base/tdelibs-${PV}
	atlantikdesigner? ( >=trinity-base/tdegames-${PV} )
	noatun? ( >=trinity-base/tdemultimedia-${PV} )
	kaddressbook? ( >=trinity-base/tdepim-${PV} )
	sys-libs/db
	virtual/jpeg
	media-libs/libsdl
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
	-DCMAKE_BUILD_TYPE="RelWithDebInfo"
	-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
	-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
	-DCMAKE_SKIP_RPATH=OFF
	-DCMAKE_INSTALL_RPATH="${TDEDIR}/$(get_libdir)"
	-DCMAKE_VERBOSE_MAKEFILE=ON
	-DWITH_GCC_VISIBILITY=OFF
	-DBIN_INSTALL_DIR="${TDEDIR}/bin"
	-DDOC_INSTALL_DIR="${TDEDIR}/share/doc"
	-DINCLUDE_INSTALL_DIR="${TDEDIR}/include"
	-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
	-DSHARE_INSTALL_PREFIX="${TDEDIR}/share"
	-DWITH_ALL_OPTIONS=ON
	-DWITH_ARTS=$(usex arts ON OFF)
	-DWITH_SDL=ON
	-DWITH_BERKELEY_DB=ON
	-DWITH_TEST=OFF
	-DBUILD_ALL=ON
	-DWITH_XMMS=OFF
	-DBUILD_ATLANTIKDESIGNER=$(usex atlantikdesigner ON OFF)
	-DBUILD_DOC=ON
	-DBUILD_KADDRESSBOOK_PLUGINS=$(usex kaddressbook ON OFF)
	-DBUILD_KATE_PLUGINS=ON
	-DBUILD_KICKER_APPLETS=ON
	-DBUILD_KNEWSTICKER_SCRIPTS=ON
	-DBUILD_KONQ_PLUGINS=ON
	-DBUILD_KSIG=ON
	-DBUILD_NOATUN_PLUGINS=$(usex noatun ON OFF)
	-DBUILD_RENAMEDLG_PLUGINS=ON
	-DBUILD_TDEFILE_PLUGINS=ON
	-DBUILD_TUTORIALS=OFF

	)

	 cmake-utils_src_configure
}
