# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit versionator multilib cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="Avahi Multicast DNS Responder (TQT Support)."
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/dependencies/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="trinity-base/tdenv
	sys-apps/dbus
	dev-qt/tqtinterface"
RDEPEND="$DEPEND"

S="${WORKDIR}/dependencies/${PN}"

TQT="/usr/tqt3"
TDEDIR="/opt/trinity"

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	mycmakeargs=(
	-DQT_INCLUDE_DIR="${TQT}/include"
	-DCMAKE_CXX_FLAGS="-L${TQT}/lib"
	-DCMAKE_INSTALL_PREFIX=${TDEDIR}
	)

	 cmake-utils_src_configure
}