# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"


inherit versionator multilib cmake-utils desktop flag-o-matic gnome2-utils


DESCRIPTION="GTK style engine which uses the active TDE style to draw its widgets"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/applications/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

DEPEND="
	dev-qt/tqtinterface
	trinity-base/tdelibs
	trinity-base/tdebase
	dev-util/cmake
	dev-util/desktop-file-utils
	sys-devel/gettext
	sys-devel/libtool
"
RDEPEND="${RDEPEND}"

S="${WORKDIR}/applications/${PN}"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/$(get_libdir)/pkgconfig
	export QTDIR=$TQT
	export LIBDIR=/opt/trinity/lib
	mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=${TDEDIR}
		-DCMAKE_BUILD_TYPE="RelWithDebInfo"
		-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
		-DCMAKE_SKIP_RPATH=OFF
		-DCMAKE_INSTALL_RPATH="${TDEDIR}/$(get_libdir)"
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DWITH_GCC_VISIBILITY=OFF
		-DDATA_INSTALL_DIR="${TDEDIR}/share"
		-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
		-DSHARE_INSTALL_PREFIX="${TDEDIR}/share"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodir ${TDEDIR}/share/kgtk
	insinto ${TDEDIR}/share/kgtk
	doins ${FILESDIR}/{gtk-qt-engine.rc.sh,gtkrc-2.0-kde4,gtkrc-2.0-kde-kde4}
}

