# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"


inherit eutils desktop flag-o-matic gnome2-utils


DESCRIPTION="GTK3 style engine which uses the active TDE style to draw its widgets"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/applications/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

DEPEND="
	dev-qt/tqtinterface
	trinity-base/tdelibs
	trinity-base/tdebase
	sys-devel/libtool
	sys-devel/autoconf
	sys-devel/automake
	virtual/pkgconfig
	sys-devel/gettext
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/applications/${PN}"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"


src_prepare() {
	cd ${S}/admin
	libtoolize -c
        cp -Rp /usr/share/aclocal/libtool.m4 "${S}/admin/libtool.m4.in"
	sed 's#$(KDE_INCLUDES)/tde#$(KDE_INCLUDES)#' -i "${S}/tdegtk/Makefile.am"
	sed 's#$(KDE_INCLUDES)/tde#$(KDE_INCLUDES)#' -i "${S}/tests/Makefile.am"
        eapply_user
}

src_configure() {
	export PREFIX=${TDEDIR}
	unset TDE_FULL_SESSION TDEROOTHOME TDEDIR TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/$(get_libdir)/pkgconfig
	emake -f admin/Makefile.common
        ./configure --prefix=${PREFIX} \
		--includedir=${PREFIX}/include \
		--enable-new-ldflags \
		--libdir="${PREFIX}/$(get_libdir)" \
		--bindir="${PREFIX}/bin" \
		--exec-prefix="${PREFIX}" \
		--disable-dependency-tracking \
		--disable-debug \
		--enable-final \
		--enable-closure \
		--enable-rpath
}
