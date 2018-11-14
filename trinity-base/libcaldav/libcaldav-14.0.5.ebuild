# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"


inherit eutils flag-o-matic toolchain-funcs


DESCRIPTION=""
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/dependencies/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

DEPEND="
	dev-qt/tqtinterface"
RDEPEND="${RDEPEND}"

S="${WORKDIR}/dependencies/${PN}"

TQT="/opt/trinity/opt/trinity"
TDEDIR="/opt/trinity"

src_prepare() {
	export PKG_CONFIG_PATH=:/opt/trinity/lib64/pkgconfig
	./autogen.sh
	eapply_user
}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/lib64/pkgconfig
	./configure --prefix=${TDEDIR}  --libdir=${TDEDIR}/$(get_libdir)
}

