# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"


inherit eutils desktop flag-o-matic gnome2-utils


DESCRIPTION="KMyMoney is the Personal Finance Manager for TDE"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/applications/${PN}-R${PV}.tar.bz2"

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
	app-text/opensp
	app-misc/fdupes
	app-text/recode
	dev-libs/libofx
	app-text/openjade
"
RDEPEND="${RDEPEND}"

S="${WORKDIR}/applications/${PN}"

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
        cp /usr/share/libtool/build-aux/ltmain.sh "${S}/admin/ltmain.sh"
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
		--with-qmake="${TDEDIR}/bin/tqmake"
		--with-qt-dir="${TDEDIR}"
		--disable-sqlite3
		--disable-pdf-docs
		--enable-ofxplugin
		--enable-ofxbanking
		--enable-qtdesigner)
	./configure ${myconf[@]}
}