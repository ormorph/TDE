# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

inherit cmake-utils  desktop flag-o-matic gnome2-utils 

DESCRIPTION="Trinity libraries needed by all TDE programs."
HOMEPAGE="http://www.trinitydesktop.org/"
VER="r14.0.x"

SRC_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz
	https://mirror.git.trinitydesktop.org/cgit/libltdl/snapshot/libltdl-r${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE+=" alsa avahi -arts cups consolekit fam jpeg2k lua lzma networkmanager openexr
	spell sudo tiff utempter upower udisks old_udisks +xcomposite +xrandr elficon"

MY_DEPEND="
	dev-qt/tqtinterface
	>=dev-libs/libxslt-1.1.16
	>=dev-libs/libxml2-2.6.6
	>=dev-libs/libpcre-6.6
	net-dns/libidn
	app-text/ghostscript-gpl
	>=dev-libs/openssl-0.9.7d:=
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/libart_lgpl
	sys-apps/dbus
	sys-libs/db
	dev-libs/dbus-tqt
	dev-libs/dbus-1-tqt
	x11-libs/libXcursor
	x11-libs/libXrender
	alsa? ( media-libs/alsa-lib )
	avahi? ( net-dns/avahi )
	cups? ( >=net-print/cups-1.1.19 )
	fam? ( virtual/fam )
	jpeg2k? ( media-libs/jasper )
	lua? ( dev-lang/lua:* )
	openexr? ( >=media-libs/openexr-1.2.2-r2 )
	spell? ( >=app-dicts/aspell-en-6.0.0 >=app-text/aspell-0.60.5 )
	sudo? ( app-admin/sudo )
	tiff? ( media-libs/tiff:= )
	utempter? ( sys-libs/libutempter )
	networkmanager? ( net-misc/networkmanager )
	lzma? ( app-arch/xz-utils )
	xrandr? ( >=x11-libs/libXrandr-1.2 )
	xcomposite? ( x11-libs/libXcomposite )
	arts? ( trinity-base/arts )
	elficon? ( trinity-apps/libr )"
# NOTE: upstream lacks avahi support, so the usex flag is currenly masked
# TODO: add elfres support via libr (not in portage now)

BDEPEND="
	trinity-base/tde-common-cmake
"
DEPEND+=" ${MY_DEPEND}
	trinity-base/tqca
	trinity-base/tqca-tls
	trinity-base/libcaldav
	trinity-base/libcarddav
	dev-python/sip
	"
RDEPEND+=" ${MY_DEPEND}
	consolekit? ( sys-auth/consolekit )
	upower? ( sys-power/upower )
	udisks? ( sys-fs/udisks:2 )
	old_udisks? ( sys-fs/udisks:0 )"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"
S="${WORKDIR}/${PN}-r${PV}"

#BUILD_DIR="${S}"
pkg_setup() {
	if [[ "$ARCH" == "amd64" ]]; then
		export LIBDIRSUFFIX="64"
	else
		export LIBDIRSUFFIX=""
	fi
}

src_prepare() {
	cp -rf ${WORKDIR}/libltdl-r${PV}/. ${S}/libltdl || die
	rm ${S}/mimetypes/application/x-mplayer2.desktop
	sed -i '/x-mplayer2.desktop/d' ${S}/mimetypes/application/CMakeLists.txt
	sed -i '/x-mplayer2.desktop/d' ${S}/mimetypes/application/Makefile.am
	cmake-utils_src_prepare
}

src_configure() {
	cp -rf ${TDEDIR}/share/cmake .
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/$(get_libdir)/pkgconfig:/usr/$(get_libdir)/pkgconfig:$PKG_CONFIG_PATH
	export LD_LIBRARY_PATH={$LD_LIBRARY_PATH}:${TDEDIR}/$(get_libdir)
	mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=${TDEDIR}
		-DLIB_SUFFIX=${LIBDIRSUFFIX}
		-platform linux-g++-64 
		-DWITH_LIBIDN=ON
		-DWITH_SSL=ON
		-DWITH_LIBART=ON
		-DWITH_PCRE=ON
		-DWITH_HSPELL=OFF
		-DWITH_GCC_VISIBILITY=OFF
		-DWITH_ALSA=$(usex alsa ON OFF)
		-DWITH_AVAHI=$(usex avahi ON OFF)
		-DWITH_CUPS=$(usex cups ON OFF)
		-DWITH_INOTIFY=$(usex kernel_linux ON OFF)
		-DWITH_JASPER=$(usex jpeg2k ON OFF)
		-DWITH_LUA=$(usex lua ON OFF)
		-DWITH_LZMA=$(usex lzma ON OFF)
		-DWITH_OPENEXR=$(usex openexr ON OFF)
		-DWITH_ASPELL=$(usex spell ON OFF)
		-DWITH_GAMIN=$(usex fam ON OFF)
		-DWITH_TIFF=$(usex tiff ON OFF)
		-DWITH_UTEMPTER=$(usex utempter ON OFF)
		-DWITH_UPOWER=$(usex upower ON OFF)
		-DWITH_UDISKS=$(usex old_udisks ON OFF)
		-DWITH_UDISKS2=$(usex udisks ON OFF)
		-DWITH_CONSOLEKIT=$(usex consolekit ON OFF)
		-DWITH_NETWORK_MANAGER_BACKEND=$(usex networkmanager ON OFF)
		-DWITH_XCOMPOSITE=$(usex  xcomposite ON OFF)
		-DWITH_XRANDR=$(usex  xrandr ON OFF)
		-DWITH_ELFICON=$(usex elficon ON OFF )
		-DWITH_ARTS=$(usex arts ON OFF )
	)

	cmake-utils_src_configure
}

src_install() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export LD_LIBRARY_PATH={$LD_LIBRARY_PATH}:${TDEDIR}/$(get_libdir)
	cmake-utils_src_install

	dodir /etc/env.d
	# KDE implies that the install path is listed first in TDEDIRS and the usexr
	# directory (implicitly added) to be the last entry. Doing otherwise breaks
	# certain functionality. Do not break this (once again *sigh*), but read the code.
	# KDE saves the installed path implicitly and so this is not needed, /usr
	# is set in ${TDEDIR}/share/config/kdeglobals and so TDEDIRS is not needed.

	# List all the multilib libdirs
	local libdirs pkgconfigdirs
	for libdir in $(get_all_libdirs); do
		libdirs="${TDEDIR}/${libdir}:${libdirs}"
	done

	cat <<EOF >"${D}/etc/env.d/45trinitypaths-${SLOT}" # number goes down with version upgrade
PATH=${TDEDIR}/bin
ROOTPATH=${TDEDIR}/sbin:${TDEDIR}/bin
LDPATH=${libdirs#:}${TDEDIR}/$(get_libdir)/trinity:
MANPATH=${TDEDIR}/share/man
CONFIG_PROTECT="${TDEDIR}/share/config ${TDEDIR}/env ${TDEDIR}/shutdown /usr/share/config"
#TDE_IS_PRELINKED=1
# Excessive flushing to disk as in releases before KDE 3.5.10. Usually you don't want that.
#TDE_EXTRA_FSYNC=1
XDG_DATA_DIRS="${TDEDIR}/share"
PKG_CONFIG_PATH="${TDEDIR}/$(get_libdir)/pkgconfig"
XDG_CONFIG_DIRS="${TDEDIR}/etc/xdg"
EOF

	# Make sure the target for the revdep-rebuild stuff exists. Fixes bug 184441.
	dodir /etc/revdep-rebuild

cat <<EOF >"${D}/etc/revdep-rebuild/50-trinity-${SLOT}"
SEARCH_DIRS="${TDEDIR}/bin ${TDEDIR}/lib*"
EOF

#	trinity-base_create_tmp_docfiles
#	trinity-base_install_docfiles
}

pkg_postinst () {
	if usex sudo; then
		einfo "Remember sudo usex flag sets only the defauld value"
		einfo "It can be overriden on a usexr-level by adding:"
		einfo "  [super-usexr-command]"
		einfo "    super-usexr-command=su"
		einfo "To the kdeglobal config file which is should be usually"
		einfo "located in the ~/.trinity/share/config/ directory."
	fi
}
