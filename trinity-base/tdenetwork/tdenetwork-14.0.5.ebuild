# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator multilib cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="This metapackage includes a collection of network and networking related"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="gadu speex openslp meanwhile"

DEPEND="
	trinity-base/tdebase
	trinity-base/tdelibs
	dev-util/cmake
	sys-devel/gettext
	sys-apps/coreutils
	dev-util/desktop-file-utils
	app-misc/fdupes
	dev-libs/openssl
	net-libs/gnutls
	dev-db/sqlite
	gadu? ( net-libs/libgadu )
	dev-libs/libpcre
	app-admin/gamin
	x11-libs/libXtst
	x11-libs/libXmu
	x11-libs/libXScrnSaver
	x11-libs/libXxf86vm
	net-wireless/wireless-tools
	openslp? ( net-libs/openslp )
	dev-util/valgrind
	media-libs/libv4l
	dev-libs/libxml2
	dev-libs/libxslt
	net-dns/libidn
	dev-libs/expat
	dev-libs/glib:2
	speex? ( media-libs/speex )
	media-libs/jasper
	sys-apps/acl
	meanwhile? ( net-libs/meanwhile )
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
	-DCMAKE_INSTALL_PREFIX=${TDEDIR}
	-DCMAKE_BUILD_TYPE="RelWithDebInfo"
	-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
	-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
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
	-DWITH_JINGLE=ON
	-DWITH_SPEEX=$(usex speex)
	-DWITH_WEBCAM=ON
	-DWITH_GSM=OFF
	-DWITH_XMMS=OFF
	-DWITH_ARTS=ON
	-DWITH_SLP=$(usex openslp)
	-DBUILD_ALL=ON
	-DBUILD_KOPETE_PLUGIN_ALL=ON
	-DBUILD_KOPETE_PROTOCOL_ALL=ON
	-DBUILD_KOPETE_PROTOCOL_GADU=$(usex gadu)
	-DBUILD_KOPETE_PROTOCOL_MEANWHILE=$(usex meanwhile)

	)

	 cmake-utils_src_configure
}
