# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator eutils desktop flag-o-matic gnome2-utils

DESCRIPTION="TDE Education Project "
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="-arts"

DEPEND="
	trinity-base/tde-common-admin
	trinity-base/tdebase
	virtual/pkgconfig
	sys-devel/autoconf
	sys-devel/gettext
	sys-devel/automake
	sys-devel/libtool
	sys-devel/m4
	dev-util/desktop-file-utils
	app-misc/fdupes
"
RDEPEND="$DEPEND"

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
	export PKG_CONFIG_PATH=:/opt/trinity/lib/pkgconfig
	emake -f admin/Makefile.common
	myconf=(--prefix=${TDEDIR}
		--with-qt-dir=${TDEDIR}
		--libdir=${TDEDIR}/$(get_libdir)
		--disable-kig-python-scripting)

	if use arts ; then
		./comfigure ${myconf[@]} || die
	else
		build_arts=no ./configure --without-arts ${myconf[@]} || die
	fi

}
