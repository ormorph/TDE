# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator eutils desktop flag-o-matic gnome2-utils

DESCRIPTION="Lipstik style for TDE"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

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

S="${WORKDIR}/${PN}-r${PV}"

TDEDIR="/opt/trinity"


src_prepare() {
	cp ${TDEDIR}/share/tde/admin/* ${S}/admin/
	cd ${S}/admin
	libtoolize -c
	cp -Rp /usr/share/aclocal/libtool.m4 "${S}/admin/libtool.m4.in"
	eapply_user
}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/lib/pkgconfig
	emake -f admin/Makefile.common
	build_arts=no ./configure --without-arts \
		--prefix="${TDEDIR}" \
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
		--disable-gcc-hidden-visibility || die
}
