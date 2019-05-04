# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator eutils desktop flag-o-matic gnome2-utils

DESCRIPTION="Konversation is a client for the Internet Relay Chat (IRC) protocol"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="arts"

DEPEND="
	trinity-base/tde-common-admin
	trinity-base/tdelibs
	trinity-base/tdebase
	dev-util/desktop-file-utils
	virtual/pkgconfig
	sys-devel/autoconf
	sys-devel/gettext
	sys-devel/automake
	sys-devel/libtool
	sys-devel/m4
	x11-libs/libXi
	arts? ( trinity-base/arts )
"
RDEPEND="$DEPEND"

S="${WORKDIR}/${PN}-r${PV}"

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
	export PKG_CONFIG_PATH=:/opt/trinity/lib/pkgconfig
	emake -f admin/Makefile.common
	myconf=(--prefix="${TDEDIR}"
		--exec-prefix="${TDEDIR}"
		--bindir="${TDEDIR}/bin"
		--datadir="${TDEDIR}/share"
		--includedir="${TDEDIR}/include"
		--libdir="${TDEDIR}/$(get_libdir)"
		--disable-dependency-tracking
		--disable-debug
		--enable-new-ldflags
		--disable-final
		--enable-closure
		--enable-rpath
		--disable-gcc-hidden-visibility)
		use arts || myconf+=(--without-arts)
	build_arts=$(usex arts yes no) ./configure ${myconf[@]} || die

}
