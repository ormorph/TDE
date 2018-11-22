# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"


inherit versionator multilib cmake-utils desktop flag-o-matic gnome2-utils


DESCRIPTION=""
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="xscreensaver gnokii"
SLOT="0"

DEPEND="
	dev-qt/tqtinterface
	dev-libs/glib:2
	trinity-base/arts
	trinity-base/tdelibs
	trinity-base/libcaldav
	dev-util/cmake
	app-misc/fdupes
	dev-util/desktop-file-utils
	app-crypt/gpgme
	sys-devel/flex
	dev-libs/libical
	dev-libs/boost
	dev-libs/libpcre
	net-dns/libidn:0
	dev-libs/openssl
	xscreensaver? ( x11-misc/xscreensaver )
	gnokii? ( app-mobilephone/gnokii )
"
RDEPEND="${RDEPEND}"


S="${WORKDIR}/${PN}"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/$(get_libdir)/pkgconfig
	export QTDIR=$TQT
	export LIBDIR=/opt/trinity/lib
	mycmakeargs=(
		-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
		-DCMAKE_SKIP_RPATH=OFF
		-DCMAKE_INSTALL_RPATH="${TDEDIR}/$(get_libdir)"
		-DCMAKE_NO_BUILTIN_CHRPATH=ON
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCMAKE_PROGRAM_PATH="${TDEDIR}/bin"
		-DWITH_GCC_VISIBILITY=OFF
		-DCMAKE_INSTALL_PREFIX=${TDEDIR}
		-DBIN_INSTALL_DIR="${TDEDIR}/bin"
		-DCONFIG_INSTALL_DIR="/etc/trinity"
		-DINCLUDE_INSTALL_DIR="${TDEDIR}/include"
		-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
		-DSHARE_INSTALL_PREFIX="${TDEDIR}/share"
		-DWITH_ARTS=ON
		
		-DWITH_SASL=ON
		-DWITH_NEWDISTRLISTS=ON
		-DWITH_GNOKII=$(usex gnokii)
		-DWITH_EXCHANGE=ON
		-DWITH_EGROUPWARE=ON
		-DWITH_KOLAB=ON
		-DWITH_SLOX=ON
		-DWITH_GROUPWISE=ON
		-DWITH_FEATUREPLAN=ON
		-DWITH_GROUPDAV=ON
		-DWITH_BIRTHDAYS=ON
		-DWITH_NEWEXCHANGE=ON
		-DWITH_SCALIX=ON
		-DWITH_CALDAV=ON
		-DWITH_CARDDAV=ON
		-DWITH_INDEXLIB=ON
#		-DBUILD_KITCHENSYNC=ON
		-DWITH_XSCREENSAVER=$(usex xscreensaver)
		-DBUILD_ALL=ON
		
	)

	cmake-utils_src_configure
}

