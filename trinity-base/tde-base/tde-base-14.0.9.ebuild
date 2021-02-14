# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

inherit eutils


DESCRIPTION="tdebase minimal package - merge this to pull in all tdebase-derived packages"
HOMEPAGE="http://www.trinitydesktop.org/"
LICENSE="GPL-2"

SLOT="0"
IUSE="+webdev +redcore powermanagement xscreensaver"
KEYWORDS="~arm ~arm64 ~x86 ~amd64"

RDEPEND="~trinity-base/tde-minimal-${PV}
	~trinity-base/tdemultimedia-${PV}
	~trinity-base/tdeutils-${PV}
	~trinity-base/tdegraphics-${PV}
	webdev? ( ~trinity-base/tdewebdev-${PV} )
	~trinity-apps/dolphin-${PV}
	~trinity-apps/gwenview-${PV}
	trinity-apps/tde-style-lipstik
	trinity-apps/tde-style-qtcurve
	trinity-apps/twin-style-crystal
	~trinity-apps/kbfx-${PV}
	~trinity-apps/kcmautostart-${PV}
	redcore? ( x11-themes/redcore-artwork-core )
	powermanagement? ( trinity-apps/tdepowersave )
	xscreensaver? ( trinity-base/tdebase[xscreensaver]
			trinity-base/tdeutils[xscreensaver] 
			trinity-base/tdetoys )
"

S=${WORKDIR}

