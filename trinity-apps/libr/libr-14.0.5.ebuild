# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator eutils desktop flag-o-matic gnome2-utils

DESCRIPTION="Dolphin focuses on being only a file manager"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://ftp.fau.de/trinity/trinity-r14.0.0/debian/pool/main/${PN}/${PN}/${PN}_${PV}.orig.tar.xz"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="
	trinity-base/tdelibs
	trinity-base/tdebase
	dev-util/desktop-file-utils
"
RDEPEND="$DEPEND"

S="${WORKDIR}/${PN}-trinity-${PV}"

TDEDIR="/opt/trinity"


src_configure() {
	./autogen.sh
	econf
}
