# Copyright 1999-20120 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator eutils desktop autotools

DESCRIPTION="Gwenview is an image viewer for TDE"
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
IUSE=""

DEPEND="
	>=trinity-base/tdelibs-${PV}
	>=trinity-base/tdebase-${PV}
	=trinity-apps/gwenview-i18n-${PV}
	dev-util/desktop-file-utils
	trinity-base/tde-common-admin
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/m4
	sys-devel/libtool
	virtual/pkgconfig
	sys-devel/gettext
	trinity-lib/exiv2
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
	export PKG_CONFIG_PATH=:/opt/trinity/lib/pkgconfig
	emake -f admin/Makefile.common
	build_arts=no ./configure --without-arts \
		--prefix="${TDEDIR}" \
		--bindir="${TDEDIR}/bin" \
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

src_install() {
	MAKEOPTS="-j1"
	emake install DESTDIR=${D} || die
}
