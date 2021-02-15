# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"


inherit eutils


DESCRIPTION="A lightweight, speed optimized color management engine"
HOMEPAGE="http://www.littlecms.com"

SRC_URI="https://sourceforge.net/projects/${PN}/files/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
SLOT="1"
IUSE=""

RDEPEND="
        virtual/jpeg
        media-libs/tiff
"
DEPEND="${RDEPEND}"

PATCHES=( ${FILESDIR}/${PN}-aarch64.patch )

TDEDIR="/opt/trinity"

src_configure() {
	export PREFIX=${TDEDIR}
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${TDEDIR}/$(get_libdir)/pkgconfig
        ./configure --prefix=${PREFIX} \
		--libdir=${PREFIX}/$(get_libdir) || die
}
