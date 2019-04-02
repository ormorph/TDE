# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"


inherit eutils desktop flag-o-matic gnome2-utils


DESCRIPTION="Yakuake is a Quake-style terminal emulator based on TDE Konsole technology"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="-arts"
SLOT="0"

DEPEND="
	trinity-base/tde-common-admin
	trinity-base/tdelibs
	trinity-base/tdebase
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/libtool
	virtual/pkgconfig
	app-misc/fdupes
"
RDEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-r${PV}"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

src_prepare() {
	cp -rf ${TDEDIR}/share/tde/admin ${S}/
	cd ${S}/admin
        libtoolize -c
        cp -Rp /usr/share/aclocal/libtool.m4 "${S}/admin/libtool.m4.in"
        eapply_user
}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export CXXFLAGS="$CXXFLAGS -std=c++11"
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/trinity/$(get_libdir)/pkgconfig
	emake -f admin/Makefile.common

	myconf=(--prefix=${TDEDIR} --libdir=${TDEDIR}/$(get_libdir)
		--exec-prefix=${TDEDIR}
		--datadir="${TDEDIR}/share"
		--bindir="${TDEDIR}/bin"
		--mandir="${TDEDIR=}/man"
		--includedir=${TDEDIR}/include
		--disable-dependency-tracking
		--disable-debug
		--enable-new-ldflags
		--disable-final
		--enable-closure
		--enable-rpath
		--disable-gcc-hidden-visibility
)
	if use arts ; then
		./configure ${myconf[@]}
	else
		build_arts=no ./configure --without-arts ${myconf[@]}
	fi
}
