# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator multilib cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="This is a set of widget styles for Trinity based apps"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/applications/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="
	trinity-base/tdelibs
	trinity-base/tdebase
	dev-util/cmake
	dev-util/desktop-file-utils
	sys-devel/libtool
	virtual/pkgconfig
	sys-devel/gettext
	app-misc/fdupes
	net-dns/libidn
	app-admin/gamin
	virtual/acl
	dev-libs/openssl
"
RDEPEND="$DEPEND"

S="${WORKDIR}/applications/${PN}"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/lib/pkgconfig
	mycmakeargs=(
	-DCMAKE_BUILD_TYPE="RelWithDebInfo"
	-DCMAKE_INSTALL_PREFIX=${TDEDIR}
	-DBIN_INSTALL_DIR="${TDEDIR}/bin"
	-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
	-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
	-DCMAKE_SKIP_RPATH=OFF
	-DCMAKE_INSTALL_RPATH="${TDEDIR}/$(get_libdir)"
	-DCMAKE_VERBOSE_MAKEFILE=ON
	-DWITH_GCC_VISIBILITY=OFF
	-DINCLUDE_INSTALL_DIR="${TDEDIR}/include"
	-DQTC_QT_ONLY=false
	-DQTC_STYLE_SUPPORT=true
	-DSHARE_INSTALL_PREFIX="${TDEDIR}/share"
	-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
	-DBUILD_ALL=ON
	)

	 cmake-utils_src_configure
}
