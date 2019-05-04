# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit eutils


DESCRIPTION="Common cmake modules for Trinity Desktop Environment "
HOMEPAGE="http://www.trinitydesktop.org/"
LICENSE="GPL-2"
RESTRICT="nomirror"
MY_PN="cmake"

SRC_URI="https://mirror.git.trinitydesktop.org/cgit/${MY_PN}/snapshot/${MY_PN}-r${PV}.tar.gz"

SLOT="0"
IUSE=""
KEYWORDS="x86 amd64"

RDEPEND="dev-util/cmake
"

S="${WORKDIR}/${MY_PN}-r${PV}"
TDEDIR="/opt/trinity"

src_install() {
	dodir ${TDEDIR}/share/cmake/modules
	insinto ${TDEDIR}/share/cmake/modules
	doins modules/*
	exeinto ${TDEDIR}/share/cmake
	doexe *
}
