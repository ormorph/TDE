# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"


inherit eutils desktop flag-o-matic gnome2-utils


DESCRIPTION="A highly configurable graphical IRC client with an MDI interface"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

DEPEND="
	trinity-base/tdelibs
	trinity-base/tdebase
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/libtool
	virtual/pkgconfig
	sys-devel/gettext
	app-misc/fdupes
	dev-util/desktop-file-utils
"
RDEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-r${PV}"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"
MAKEOPTS="-j1"

src_prepare() {
	cd ${S}/admin
	libtoolize -c
        cp -Rp /usr/share/aclocal/libtool.m4 "${S}/admin/libtool.m4.in"
#	sed -i "${S}/admin/acinclude.m4.in" \
#-i "${S}/src/kvilib/tal/kvi_tal_application.cpp" \
#-e "/TDEApplication/ s|\")|\", true, true, true)|"
        eapply_user
}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	#export CXXFLAGS="$CXXFLAGS -std=c++11"
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/trinity/$(get_libdir)/pkgconfig
	./autogen.sh

	myconf=(--prefix=${TDEDIR} --libdir=${TDEDIR}/$(get_libdir)
		--exec-prefix=${TDEDIR}
		--datadir="${TDEDIR}/share"
		--bindir="${TDEDIR}/bin"
		--mandir="${TDEDIR=}/man"
		--includedir=${TDEDIR}/include
		--disable-dependency-tracking
		--disable-debug
		--enable-wall
		--with-pic
		--with-big-channels
		--enable-perl
		--with-ix86-asm
		--with-kde-services-dir="${TDEDIR}/share/services"
		--with-kde-library-dir="${TDEDIR}/$(get_libdir)"
		--with-kde-include-dir="${TDEDIR}/include"
		--with-qt-name=tqt
		--with-qt-library-dir="${TDEDIR}/$(get_libdir)"
		--with-qt-include-dir="${TDEDIR}/include"
		--with-qt-moc="${TDEDIR}/bin/tqmoc"
)
	./configure ${myconf[@]}
	
}
