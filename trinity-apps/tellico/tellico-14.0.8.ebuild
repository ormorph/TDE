# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

inherit cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="Icollection manager for books, videos, music [Trinity]"
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
IUSE="kcddb"

BDEPEND="
	trinity-base/tde-common-cmake
	dev-util/desktop-file-utils
	virtual/pkgconfig
	app-misc/fdupes
"
DEPEND="
	>=trinity-base/tdelibs-${PV}
	>=trinity-base/tdebase-${PV}
	virtual/acl
	net-dns/libidn
	dev-libs/libpcre
	dev-libs/openssl
	app-text/poppler
	dev-libs/yaz
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/libgcrypt
	media-libs/libv4l
	media-libs/exempi
	app-admin/gamin
	sys-apps/attr
	kcddb? ( trinity-base/tdemultimedia )
"
RDEPEND="$DEPEND"

if [[ ${PV} = 14.0.999 ]] || [[ ${PV} = 9999 ]]; then
	S="${WORKDIR}/${P}"
else
	S="${WORKDIR}/${PN}-r${PV}"
fi

TDEDIR="/opt/trinity"


src_configure() {
	cp -rf ${TDEDIR}/share/cmake .
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${TDEDIR}/$(get_libdir)/pkgconfig
	export QTDIR=$TQT
	mycmakeargs=(
		-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
		-DCMAKE_SKIP_RPATH=OFF
		-DCMAKE_INSTALL_RPATH="${TDEDIR}/$(get_libdir)"
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCMAKE_PROGRAM_PATH="${TDEDIR}/bin"
		-DWITH_GCC_VISIBILITY=OFF
		-DCMAKE_INSTALL_PREFIX=${TDEDIR}
		-DBIN_INSTALL_DIR="${TDEDIR}/bin"
		-DCONFIG_INSTALL_DIR="/etc/trinity"
		-DINCLUDE_INSTALL_DIR="${TDEDIR}/include"
		-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
		-DSHARE_INSTALL_PREFIX="${TDEDIR}/share"
		-DWITH_ALL_OPTIONS=ON
		-DWITH_LIBKCDDB=$(usex kcddb ON OFF)
		-DWITH_LIBKCAL=ON
		-DWITH_LIBBTPARSE=OFF
		-DWITH_SAX_LOADER=ON
)
	cmake-utils_src_configure
}
