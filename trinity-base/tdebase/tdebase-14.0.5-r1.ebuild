# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit versionator multilib cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="Base package of the Trinity Desktop Environment (TDE)"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE+=" +arts +pam samba +upower xinerama +xrandr +xrender"

DEPEND="
	dev-qt/tqtinterface
	sys-libs/libraw1394
	media-libs/openexr
	www-misc/htdig
	dev-libs/libbsd
	x11-misc/xscreensaver
	media-libs/mesa
	net-libs/libtirpc
	arts? ( trinity-base/arts )
	samba? ( net-fs/samba )
	xrandr? ( x11-libs/libXrandr )
	xinerama? ( x11-libs/libXinerama )
	upower? ( sys-power/upower )
	>=trinity-base/tdelibs-14.0.5
	dev-libs/libconfig
	dev-libs/cyrus-sasl
	sys-apps/lm_sensors
	dev-libs/libgamin
	dev-libs/glib:2
	x11-libs/libXext
	x11-libs/libxcb
	x11-libs/libX11
	x11-libs/libXtst
	media-libs/libsndfile
	net-libs/libasyncns
	media-gfx/graphite2
	x11-libs/libXfixes
	x11-libs/libXau
	x11-libs/libXdmcp
	media-libs/flac
	media-libs/libogg
	media-libs/libvorbis
	sys-apps/file
	sys-apps/attr
	x11-libs/libICE
	x11-libs/libSM
	net-dns/libidn
	sys-apps/acl
	x11-libs/libXext
"
RDEPEND="$DEPEND"

#S="${WORKDIR}/dependencies/${PN}"
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

#src_prepare() {
#	epatch ${FILESDIR}/one.patch
	# no compton
#	sed -i "twin/CMakeLists.txt" -e "/compton-tde/ s/^/#/"
#	cmake-utils_src_prepare
#}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/lib/pkgconfig
	export LD_LIBRARY_PATH={$LD_LIBRARY_PATH}:${TDEDIR}/$(get_libdir)
	mycmakeargs=(
		-DCMAKE_BUILD_TYPE="RelWithDebInfo"
#		-DCMAKE_INSTALL_PREFIX=${TDEDIR}
                -DCMAKE_C_FLAGS="${CFLAGS} -lbsd -L${TQT}/lib $(pkg-config --cflags --libs libtirpc)"
                -DCMAKE_CXX_FLAGS="${CXXFLAGS} -lbsd -L${TQT}/lib $(pkg-config --cflags --libs libtirpc)"
		-DCMAKE_SKIP_RPATH=OFF
		-DCMAKE_INSTALL_RPATH="${TDEDIR}/$(get_libdir)"
		-DCMAKE_NO_BUILTIN_CHRPATH=ON
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DWITH_GCC_VISIBILITY=ON

		-DBIN_INSTALL_DIR="${TDEDIR}/bin"
		-DCONFIG_INSTALL_DIR="/etc/trinity"
		-DINCLUDE_INSTALL_DIR="${TDEDIR}/include"
		-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
		-DSHARE_INSTALL_PREFIX="${TDEDIR}/share"
		-DCONFIG_INSTALL_DIR="/etc/trinity"
		-DSYSCONF_INSTALL_DIR="/etc/trinity"
		-DXDG_MENU_INSTALL_DIR="/etc/xdg/menus"

		-DWITH_ALL_OPTIONS=ON
		-DWITH_SASL=ON
		-DWITH_LDAP=ON
		-DWITH_SAMBA=$(usex samba)
#		-DWITH_OPENEXR=OFF  #flag
		-DWITH_XCOMPOSITE=ON
		-DWITH_XCURSOR=ON
		-DWITH_XFIXES=ON
#  %{?!with_xrandr:-DWITH_XRANDR=OFF}
		-DWITH_XRENDER=$(usex xrender)
#  %{?!with_libconfig:-DWITH_LIBCONFIG=OFF} \
		-DWITH_PCRE=ON
# %{?!with_xtest:-DWITH_XTEST=OFF} \
		-DWITH_OPENGL=ON
#  %{?!with_xscreensaver:-DWITH_XSCREENSAVER=OFF} \
#  %{?!with_libart:-DWITH_LIBART=OFF} \
		-DWITH_LIBUSB=ON
		-DWITH_LIBRAW1394=ON
		-DWITH_SUDO_TDESU_BACKEND=OFF
		-DWITH_SUDO_KONSOLE_SUPER_USER_COMMAND=OFF
		-DWITH_PAM=$(usex pam)
#		-DWITH_PAM=ON
		-DWITH_USBIDS="/usr/share/misc/usb.ids"
		-DWITH_SHADOW=OFF
		-DWITH_XDMCP=ON
		-DWITH_XINERAMA=$(usex xinerama)
		-DWITH_ARTS=$(usex arts)
		-DWITH_I8K=ON
		-DWITH_SENSORS=ON
#		{?with_hal:-DWITH_HAL=ON} \
#		%{?!with_tdehwlib:-DWITH_TDEHWLIB=OFF} \
		-DWITH_UPOWER=$(usex upower)
#		 %{?!with_elficon:-DWITH_ELFICON=OFF} \
		-DWITH_ELFICON=OFF

		-DBUILD_ALL=ON
#		%if 0%{?suse_version}
#		-DKCHECKPASS_PAM_SERVICE="xdm"
#		-DTDM_PAM_SERVICE="xdm"
#		-DTDESCREENSAVER_PAM_SERVICE="xdm"
#		%else
#		-DKCHECKPASS_PAM_SERVICE="kcheckpass-trinity" \
#		-DTDM_PAM_SERVICE="tdm-trinity" \
#		-DTDESCREENSAVER_PAM_SERVICE="tdescreensaver-trinity" \
#		%endif
#		%{!?with_kbdledsync:-DBUILD_TDEKBDLEDSYNC=OFF} \
#		%{!?with_tsak:-DBUILD_TSAK=OFF} \
#		%if 0%{?fedora} >= 22 || 0%{?suse_version} >= 1320
		-DHTDIG_SEARCH_BINARY="/usr/bin/htdig"


#		-DCMAKE_CXX_FLAGS="-L${TQT}/lib"
#		-DCMAKE_INSTAL_PREFIX=${TDEDIR}
	)

	if use pam ; then
	mycmakeargs+=(
		-DKCHECKPASS_PAM_SERVICE="kcheckpass-trinity" \
		-DTDM_PAM_SERVICE="tdm-trinity" \
		-DTDESCREENSAVER_PAM_SERVICE="tdescreensaver-trinity" \
	)
	fi

	 cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if use pam ; then
		dodir /etc/pam.d
		insinto /etc/pam.d
		doins ${FILESDIR}/{kcheckpass-trinity,tdescreensaver-trinity}
	fi
}
