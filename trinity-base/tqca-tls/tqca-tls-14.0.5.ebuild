# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils versionator multilib flag-o-matic gnome2-utils

DESCRIPTION=""
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/dependencies/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 amd64"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/tqtinterface
	dev-libs/openssl
"
RDEPEND="$DEPEND"

S="${WORKDIR}/dependencies/${PN}"

TDEDIR="/opt/trinity"

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	myconf=" --qtdir=${TDEDIR} "
	./configure $myconf || die
}

src_install() {
	emake install INSTALL_ROOT=${D}
}
