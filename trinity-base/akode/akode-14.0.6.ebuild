# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

inherit cmake-utils desktop flag-o-matic gnome2-utils rpm

DESCRIPTION="Audio-decoding framework"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+alsa +pulseaudio jack +mpc oss +mpeg "

BDEPEND="
	trinity-base/tde-common-cmake
"
DEPEND="
	trinity-base/arts
	mpc? ( dev-libs/mpc )
	dev-libs/libltdl
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	pulseaudio? ( media-sound/pulseaudio )
	mpeg? ( media-libs/libmad )
	media-libs/speex
	media-libs/libsamplerate
	media-libs/flac
	media-libs/libvorbis
	media-libs/libsndfile
"
RDEPEND="$DEPEND"

S="${WORKDIR}/${PN}-r${PV}"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

pkg_setup() {
	if [[ "$ARCH" == "amd64" ]]; then
		export LIBDIRSUFFIX="64"
	else
		export LIBDIRSUFFIX=""
	fi
}

src_prepare() {
	cp -rf ${TDEDIR}/share/cmake ${S}/
	cmake-utils_src_prepare
}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/lib/pkgconfig
	mycmakeargs=(
	-DCMAKE_INSTALL_PREFIX=${TDEDIR}
	-DLIB_SUFFIX=${LIBDIRSUFFIX}
	-DWITH_LIBLTDL=ON
	-DWITH_ALSA_SINK=$(usex alsa)
	-DWITH_JACK_SINK=$(usex jack)
	-DWITH_PULSE_SINK=$(usex pulseaudio)
	-DWITH_OSS_SINK=$(usex oss)
	-DWITH_SUN_SINK=OFF
	-DWITH_FFMPEG_DECODER=OFF
	-DWITH_MPC_DECODER=$(usex mpc)
	-DWITH_MPEG_DECODER=$(usex mpeg)
	-DWITH_SRC_RESAMPLER=ON
	-DWITH_XIPH_DECODER=ON

	)

	 cmake-utils_src_configure
}
