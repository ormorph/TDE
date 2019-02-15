# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator eutils desktop flag-o-matic gnome2-utils

DESCRIPTION="Lipstik style for TDE"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/applications/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="
	trinity-base/tdelibs
	trinity-base/tdebase
	dev-util/desktop-file-utils
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/m4
	sys-devel/libtool
	virtual/pkgconfig
	app-misc/fdupes
"
RDEPEND="$DEPEND"

S="${WORKDIR}/applications/${PN}"

TDEDIR="/opt/trinity"


src_prepare() {
	cp /usr/share/libtool/build-aux/ltmain.sh "${S}/admin/ltmain.sh"
	cp -Rp /usr/share/aclocal/libtool.m4 "${S}/admin/libtool.m4.in"
	eapply_user
}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/lib/pkgconfig
	emake -f admin/Makefile.common
	./configure --prefix="${TDEDIR}" \
		--exec-prefix="${TDEDIR}" \
		--datadir="${TDEDIR}/share" \
		--includedir="${TDEDIR}/include" \
		--libdir="${TDEDIR}/$(get_libdir)" \
		--disable-dependency-tracking \
		--disable-debug \
		--enable-new-ldflags \
		--enable-final \
		--enable-closure \
		--enable-rpath \
		--disable-gcc-hidden-visibility
}
