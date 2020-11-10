# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator eutils desktop flag-o-matic gnome2-utils

DESCRIPTION="Recipes manager for TDE"
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
IUSE="+sqlite mysql postgresql"

DEPEND="
	trinity-base/tde-common-admin
	>=trinity-base/tdelibs-${PV}
	dev-util/desktop-file-utils
	virtual/pkgconfig
	sys-devel/autoconf
	sys-devel/gettext
	sys-devel/automake
	sys-devel/libtool
	sys-devel/m4
	app-misc/fdupes
	mysql? ( dev-qt/tqt3[mysql] )
	postgresql? ( dev-db/postgresql 
		dev-qt/tqt3[postgres] )
	sqlite? ( dev-qt/tqt3[sqlite] )
"
RDEPEND="$DEPEND"

if [[ ${PV} = 14.0.999 ]] || [[ ${PV} = 9999 ]]; then
	S="${WORKDIR}/${P}"
else
	S="${WORKDIR}/${PN}-r${PV}"
fi

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
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${TDEDIR}/$(get_libdir)/pkgconfig
	emake -f admin/Makefile.common
	myconf=(--without-arts
		--prefix="${TDEDIR}"
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
		$(use_with sqlite)
		$(use_with mysql)
		$(use_with postgresql)
)
	build_arts=no ./configure ${myconf[@]} || die

}
