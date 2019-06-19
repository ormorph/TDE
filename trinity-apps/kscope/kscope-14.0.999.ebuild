# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"


inherit eutils desktop flag-o-matic gnome2-utils autotools


DESCRIPTION="Source editing environment for TDE"
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

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

DEPEND="
	trinity-base/tde-common-admin
	dev-qt/tqtinterface
	trinity-base/tdelibs
	trinity-base/tdebase
	virtual/pkgconfig
	dev-util/desktop-file-utils
	app-misc/fdupes
	sys-devel/flex
	sys-devel/gettext
	sys-devel/bison
"
RDEPEND="${DEPEND}"

if [[ ${PV} = 14.0.999 ]] || [[ ${PV} = 9999 ]]; then
	S="${WORKDIR}/${P}"
else
	S="${WORKDIR}/${PN}-r${PV}"
fi

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
	export PREFIX=${TDEDIR}
	unset TDE_FULL_SESSION TDEROOTHOME TDEDIR TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/$(get_libdir)/pkgconfig
	emake -f admin/Makefile.common
	myconf=(--without-arts
		--prefix=${PREFIX}
		--includedir=${PREFIX}/include
		--enable-new-ldflags
		--libdir="${PREFIX}/$(get_libdir)"
		--bindir="${PREFIX}/bin"
		--exec-prefix="${PREFIX}"
		--disable-dependency-tracking
		--disable-debug
		--enable-final
		--enable-closure
		--enable-rpath
		--disable-gcc-hidden-visibility
	)
	build_arts=no ./configure ${myconf[@]} || die
}
