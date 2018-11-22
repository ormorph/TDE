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
IUSE="+kmix arts juk noatun kaboodle kscd kcddb tdemid krec mpeg gstreamer cdparanoia xine flac taglib doc ogg audiofile"

REQUIRED_USE="
	arts? ( audiofile )
	cdparanoia? ( mpeg )
	krec? ( ogg )
	kscd? ( flac )
	juk? ( gstreamer )
"

DEPEND="
	trinity-base/tdebase
	gstreamer? ( media-libs/gstreamer:1.0 )
	flac? ( media-libs/flac )
	audiofile? ( media-libs/audiofile )
	cdparanoia? ( media-sound/cdparanoia )
	mpeg? ( media-libs/libmad )
	ogg? ( media-libs/libtheora
		media-libs/libogg )
	krec? ( media-sound/lame )
	media-libs/musicbrainz
	xine? ( media-libs/xine-lib )
	taglib? ( media-libs/taglib )
	arts? ( trinity-base/akode )
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
	-DWITH_ARTS_AUDIOFILE=$(usex arts)
	-DWITH_ARTS_MPEGLIB=$(usex arts)
	-DWITH_ARTS_XINE=$(usex xine)
	-DWITH_GSTREAMER=$(usex gstreamer)
	-DWITH_CDPARANOIA=$(usex cdparanoia)
	-DWITH_KSCD_CDDA=$(usex kscd)
	-DWITH_FLAC=$(usex flac)
	-DWITH_ALSA=ON
	-DWITH_TAGLIB=$(usex taglib)
	-DWITH_ARTS_AKODE=$(usex arts)
	-DBUILD_JUK=$(usex juk)
	-DBUILD_NOATUN=$(usex noatun)
	-DBUILD_TDEMID=$(usex tdemid)
	-DBUILD_ARTS=$(usex arts)
	-DBUILD_KSCD=$(usex kscd)
	-DBUILD_KABOODLE=$(usex kaboodle)
	-DBUILD_KREC=$(usex krec)
	-DBUILD_KMIX=$(usex kmix)
	-DBUILD_LIBKCDDB=$(usex kcddb)
	-DBUILD_MPEGLIB=$(usex arts)
	-DBUILD_TDEIOSLAVE=$(usex kscd)
	-DBUILD_DOC=$(usex doc)
	-DBUILD_TDEFILE_PLUGINS=ON
	)

	 cmake-utils_src_configure
}
