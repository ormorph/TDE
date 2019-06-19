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

if [[ ${PV} = 14.0.999 ]]; then
	inherit git-r3
        EGIT_REPO_URI="https://mirror.git.trinitydesktop.org/cgit/${MY_PN}"
        EGIT_BRANCH="r14.0.x"
elif [[ ${PV} = 9999 ]]; then
	inherit git-r3
        EGIT_REPO_URI="https://mirror.git.trinitydesktop.org/cgit/${MY_PN}"
else
	SRC_URI="https://mirror.git.trinitydesktop.org/cgit/${MY_PN}/snapshot/${MY_PN}-r${PV}.tar.gz"
fi

SLOT="0"
IUSE=""
KEYWORDS="x86 amd64"

RDEPEND="sys-devel/libtool
	sys-devel/automake
	sys-devel/autoconf
"

if [[ ${PV} = 14.0.999 ]] || [[ ${PV} = 9999 ]]; then
	S="${WORKDIR}/${P}"
else
	S="${WORKDIR}/${MY_PN}-r${PV}"
fi

TDEDIR="/opt/trinity"

src_install() {
	dodir ${TDEDIR}/share/tde/admin
	cp -ax ${S}/* ${D}/${TDEDIR}/share/tde/admin
}
