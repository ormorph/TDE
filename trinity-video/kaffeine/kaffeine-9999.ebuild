# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"


inherit versionator multilib desktop flag-o-matic gnome2-utils


DESCRIPTION="aRts, the Trinity sound (and all-around multimedia) server/output manager"
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
IUSE="alsa jack mp3 nas vorbis xinerama gstreamer lame"
SLOT="0"

DEPEND="
	trinity-base/tde-common-admin
	>=dev-qt/tqtinterface-${PV}
	>=trinity-base/tdelibs-${PV}
	sys-devel/libtool
	sys-devel/gettext
	sys-devel/autoconf
	sys-devel/automake
	virtual/pkgconfig
	dev-libs/libcdio
	media-sound/cdparanoia
	x11-libs/libXext
	x11-libs/libXtst
	dev-libs/libcdio-paranoia
	xinerama? ( x11-libs/libXinerama )
	gstreamer? ( media-libs/gstreamer:1.0
		media-plugins/gst-plugins-meta )
	lame? ( media-sound/lame )
	dev-libs/glib:2
	media-libs/xine-lib
	media-libs/audiofile
	mp3? ( media-libs/libmad )
	nas? ( media-libs/nas )
	alsa? ( media-libs/alsa-lib )
	vorbis? ( media-libs/libogg media-libs/libvorbis )
	jack? ( >=media-sound/jack-audio-connection-kit-0.90 )"
RDEPEND="${DEPEND}"

if [[ ${PV} = 14.0.999 ]] || [[ ${PV} = 9999 ]]; then
	S="${WORKDIR}/${P}"
else
	S="${WORKDIR}/${PN}-r${PV}"
fi

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

src_prepare() {
	cp -rf ${TDEDIR}/share/tde/admin ${S}/
	cd ${S}/admin
	libtoolize -c
	cp -Rp /usr/share/aclocal/libtool.m4 "${S}/admin/libtool.m4.in"
	sed 's/x-mplayer2.desktop//' -i ${S}/kaffeine/mimetypes/application/Makefile.am
	eapply_user
}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${TDEDIR}/$(get_libdir)/pkgconfig
	export QTDIR=$TQT
	export LIBDIR=/opt/trinity/$(get_libdir)
	emake -f admin/Makefile.common
	build_arts=no ./configure --without-arts \
		--prefix=${TDEDIR=} \
		--disable-dependency-tracking \
		--disable-debug \
		--enable-new-ldflags \
		--enable-final \
		--enable-closure \
		--enable-rpath \
		--disable-gcc-hidden-visibility \
		$(use_with xinerama ) \
		$(use_with gstreamer ) \
		$(use_with lame ) \
		--without-dvb || die
}

src_compile() {
	emake || die
}
