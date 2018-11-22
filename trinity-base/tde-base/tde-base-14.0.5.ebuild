# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit eutils


DESCRIPTION="tdebase minimal package - merge this to pull in all tdebase-derived packages"
HOMEPAGE="http://www.trinitydesktop.org/"
LICENSE="GPL-2"

SLOT="0"
IUSE=""
KEYWORDS="x86 amd64"

RDEPEND=">=trinity-base/tde-minimal-14.0.5
	trinity-base/tdemultimedia
	trinity-base/tdeutils
	trinity-base/tdegraphics
	trinity-base/tdesdk
	trinity-base/tdewebdev
	trinity-apps/dolphin
"

S=${WORKDIR}

