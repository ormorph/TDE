# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator eutils desktop flag-o-matic gnome2-utils

DESCRIPTION="Look messages into your mail server"
HOMEPAGE="http://trinitydesktop.org/"

if [[ ${PV} = 14.0.999 ]]; then
	inherit git-r3
        EGIT_REPO_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}"
        EGIT_BRANCH="r14.0.x"
	EGIT_SUBMODULES=()
elif [[ ${PV} = 9999 ]]; then
	inherit git-r3
        EGIT_REPO_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}"
	EGIT_SUBMODULES=()
else
	SRC_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"
fi

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="arts"

DEPEND="
	~trinity-base/tdelibs-${PV}
	dev-util/desktop-file-utils
	trinity-base/tde-common-admin
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/m4
	sys-devel/libtool
	virtual/pkgconfig
	app-misc/fdupes
	arts? ( trinity-base/arts )
"
RDEPEND="$DEPEND"

if [[ ${PV} = 14.0.999 ]] || [[ ${PV} = 9999 ]]; then
	S="${WORKDIR}/${P}"
else
	S="${WORKDIR}/${PN}-r${PV}"
fi

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
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${TDEDIR}/$(get_libdir)/pkgconfig
	emake -f admin/Makefile.common
	use arts || myconf+=(--without-arts)
	myconf+=(--prefix="${TDEDIR}"
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
		--disable-gcc-hidden-visibility
)
	build_arts=$(usex arts yes no) ./configure ${myconf[@]} || die

}

src_install() {
	emake install DESTDIR=${D} || die
}
