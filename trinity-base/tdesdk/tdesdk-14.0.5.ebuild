# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator multilib cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="TDE Development Kit"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="
	trinity-base/tdebase
	trinity-base/tdepim
	dev-util/cmake
	sys-devel/libtool
	app-misc/fdupes
	virtual/acl
	net-dns/libidn
	app-admin/gamin
	dev-libs/libpcre
	dev-util/desktop-file-utils
	dev-libs/libxslt
	dev-libs/libxml2
	dev-vcs/subversion
	net-libs/neon
	dev-lang/perl
	dev-libs/openssl
"
RDEPEND="$DEPEND"

S="${WORKDIR}/${PN}"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

pkg_setup() {
	if [[ "$ARCH" == "amd64" ]]; then
		export LIBDIRSUFFIX="64"
	else
		export LIBDIRSUFFIX=""
	fi
}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/lib/pkgconfig
	mycmakeargs=(
	-DCMAKE_CXX_FLAGS="${CXXFLAGS} -std=c++11"
	-DCMAKE_INSTALL_PREFIX=${TDEDIR}
	-DLIB_SUFFIX=${LIBDIRSUFFIX}
	-DWITH_DBSEARCHENGINE=ON
	-DWITH_KCAL=ON
	-DBUILD_ALL=ON
	)

	 cmake-utils_src_configure
}
