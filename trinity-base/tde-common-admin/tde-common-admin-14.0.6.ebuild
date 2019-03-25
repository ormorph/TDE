# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit eutils


DESCRIPTION="Common cmake modules for Trinity Desktop Environment "
HOMEPAGE="http://www.trinitydesktop.org/"
LICENSE="GPL-2"
RESTRICT="nomirror"
MY_PN="admin"

SRC_URI="https://git.trinitydesktop.org/cgit/${MY_PN}/snapshot/${MY_PN}-r${PV}.tar.gz"

SLOT="0"
IUSE=""
KEYWORDS="x86 amd64"

RDEPEND="sys-devel/libtool
	sys-devel/automake
	sys-devel/autoconf
"

S="${WORKDIR}/${MY_PN}-r${PV}"
TDEDIR="/opt/trinity"

src_install() {
	dodir ${TDEDIR}/share/tde/admin
	cp -ax ${S}/* ${D}/${TDEDIR}/share/tde/admin
}
