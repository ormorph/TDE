# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

inherit eutils


DESCRIPTION="tdebase minimal package - merge this to pull in all tdebase-derived packages"
HOMEPAGE="http://www.trinitydesktop.org/"
LICENSE="GPL-2"

SLOT="0"
IUSE="+webdev +redcore powermanagement"
KEYWORDS="x86 amd64"

RDEPEND=">=trinity-base/tde-minimal-14.0.6
	>=trinity-base/tdemultimedia-14.0.6
	>=trinity-base/tdeutils-14.0.6
	>=trinity-base/tdegraphics-14.0.6
	webdev? ( >=trinity-base/tdewebdev-14.0.6 )
	>=trinity-apps/dolphin-14.0.6
	>=trinity-apps/gwenview-14.0.6
	trinity-apps/tde-style-baghira
	trinity-apps/tde-style-domino
	trinity-apps/tde-style-ia-ora
	trinity-apps/tde-style-lipstik
	trinity-apps/tde-style-qtcurve
	trinity-apps/twin-style-crystal
	>=trinity-apps/kbfx-14.0.6
	>=trinity-apps/kcmautostart-14.0.6
	redcore? ( x11-themes/redcore-artwork-core )
	powermanagement? ( trinity-apps/tdepowersave )
"

S=${WORKDIR}

