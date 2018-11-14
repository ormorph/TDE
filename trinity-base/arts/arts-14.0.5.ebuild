# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"


inherit versionator multilib cmake-utils desktop flag-o-matic gnome2-utils


DESCRIPTION="aRts, the Trinity sound (and all-around multimedia) server/output manager"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/dependencies/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="alsa -artswrappersuid jack mp3 nas vorbis"
SLOT="0"

DEPEND="
	dev-qt/tqtinterface
	dev-libs/glib:2
	media-libs/audiofile
	mp3? ( media-libs/libmad )
	nas? ( media-libs/nas )
	alsa? ( media-libs/alsa-lib )
	vorbis? ( media-libs/libogg media-libs/libvorbis )
	jack? ( >=media-sound/jack-audio-connection-kit-0.90 )"
RDEPEND="${RDEPEND}"

S="${WORKDIR}/dependencies/${PN}"

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
	export PKG_CONFIG_PATH=:/opt/trinity/$(get_libdir)/pkgconfig
	export QTDIR=$TQT
	export LIBDIR=/opt/trinity/lib
	mycmakeargs=(
		-DCMAKE_CXX_FLAGS="-L${TQT}/lib"
		-DCMAKE_INSTALL_PREFIX=${TDEDIR}
		-DLIB_SUFFIX=${LIBDIRSUFFIX}
		-DWITH_MAD=$(usex mp3)
		-DWITH_ALSA=$(usex alsa)
		-DWITH_VORBIS=$(usex vorbis)
		-DWITH_JACK=$(usex jack)
		# NOTE: WITH_ESD dropped due to remove of esound long ago
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# used for realtime priority, but off by default as it is a security hazard
	use artswrappersuid && chmod u+s "${D}/${PREFIX}/bin/artswrapper"
}

pkg_postinst() {
	if ! use artswrappersuid ; then
		elog "Run chmod u+s ${PREFIX}/bin/artswrapper to let artsd use realtime priority"
		elog "and so avoid possible skips in sound. However, on untrusted systems this"
		elog "creates the possibility of a DoS attack that'll use 100% cpu at realtime"
		elog "priority, and so is off by default. See bug #7883."
		elog "Or, you can set the local artswrappersuid USE flag to make the ebuild do this."
	fi
}