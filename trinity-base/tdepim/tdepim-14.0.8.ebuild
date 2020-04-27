# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

: ${CMAKE_MAKEFILE_GENERATOR:=emake}
inherit cmake-utils desktop flag-o-matic gnome2-utils


DESCRIPTION="Personal Information Management apps from the official Trinity release"
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
IUSE="xscreensaver gnokii -arts"
SLOT="0"

BDEPEND="
	trinity-base/tde-common-cmake
	dev-util/desktop-file-utils
"
DEPEND="
	>=trinity-base/tdelibs-${PV}
	>=trinity-base/tdebase-${PV}
	dev-libs/glib:2
	arts? ( trinity-base/arts )
	>=trinity-base/libcaldav-${PV}
	>=trinity-base/libcarddav-${PV}
	app-crypt/gpgme
	app-admin/gamin
	net-misc/curl
	dev-libs/cyrus-sasl
	sys-devel/flex
	dev-libs/libical
	dev-libs/boost
	dev-libs/libpcre
	net-dns/libidn:0
	dev-libs/libical
	dev-libs/libgpg-error
	dev-libs/openssl
	xscreensaver? ( x11-misc/xscreensaver )
	gnokii? ( app-mobilephone/gnokii )
"
RDEPEND="${DEPEND}"

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
		-DWITH_ARTS=$(usex arts ON OFF)
		
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

