# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator multilib cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="The TDevelop Integrated Development Environment"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/tqt3
	trinity-base/tdelibs
	trinity-base/tdebase
	trinity-base/arts
	trinity-base/tdesdk
	dev-util/cmake
	sys-devel/libtool
	app-misc/fdupes
	dev-util/desktop-file-utils
	dev-lang/perl
	sys-devel/gettext
	dev-util/ctags
	sys-devel/flex
	dev-libs/libgamin
	net-dns/libidn
	virtual/acl
	dev-libs/openssl
	net-nds/openldap
	sys-libs/db
"
RDEPEND="$DEPEND"

S="${WORKDIR}/${PN}"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=/opt/trinity/lib/pkgconfig
	mycmakeargs=(
	-DCMAKE_INSTALL_PREFIX=${TDEDIR}
	-DCMAKE_BUILD_TYPE="RelWithDebInfo"
	-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
	-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG -L${TDEDIR}/$(get_libdir)"
	-DCMAKE_SKIP_RPATH=OFF
	-DCMAKE_INSTALL_RPATH="${TDEDIR}/$(get_libdir)"
	-DCMAKE_NO_BUILTIN_CHRPATH=ON
	-DCMAKE_VERBOSE_MAKEFILE=ON
	-DWITH_GCC_VISIBILITY=OFF
	-DBIN_INSTALL_DIR="${TDEDIR}/bin"
	-DCONFIG_INSTALL_DIR="/etc/trinity"
	-DINCLUDE_INSTALL_DIR="${TDEDIR}/include"
	-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
	-DSHARE_INSTALL_PREFIX="${TDEDIR}/share"
	-DWITH_BUILDTOOL_ALL=ON
	-DWITH_LANGUAGE_ALL=ON
	-DWITH_VCS_ALL=OFF
	-DBUILD_ALL=ON
	)

	 cmake-utils_src_configure
}
