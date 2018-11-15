# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="multimedia applications from the TDE"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="
	trinity-base/tdebase
	media-libs/gstreamer:1.0
	media-libs/flac
	media-libs/libmad
	media-sound/cdparanoia
	media-libs/libtheora
	media-sound/lame
	media-libs/musicbrainz
	media-libs/xine-lib
	media-libs/audiofile
	media-libs/taglib
	trinity-base/akode
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
	-DLIB_SUFFIX=${LIBDIRSUFFIX}
	-DBUILD_ALL=ON
	-DWITH_ARTS_AUDIOFILE=ON
	-DWITH_ARTS_MPEGLIB=ON
	-DWITH_ARTS_XINE=ON
	-DWITH_GSTREAMER=ON
	-DWITH_CDPARANOIA=ON
	-DWITH_KSCD_CDDA=ON
	-DWITH_FLAC=ON
	-DWITH_ALSA=ON
	-DWITH_TAGLIB=ON
	-DWITH_ARTS_AKODE=ON

	)

	 cmake-utils_src_configure
}
