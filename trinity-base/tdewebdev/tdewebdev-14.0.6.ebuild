# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

inherit cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="The package for web developpment"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz
	http://download.sourceforge.net/quanta/html.tar.bz2
	http://download.sourceforge.net/quanta/css.tar.bz2
	http://download.sourceforge.net/quanta/javascript.tar.bz2
	http://download.sourceforge.net/quanta/php_manual_en_20030401.tar.bz2"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

BDEPEND="
	trinity-base/tde-common-cmake
	sys-devel/libtool
	sys-devel/gettext
	sys-devel/autoconf
	sys-devel/automake
	virtual/pkgconfig
"
DEPEND="
	>=trinity-base/tdelibs-14.0.6
        >=trinity-base/tdesdk-14.0.6
        dev-libs/libxslt
        dev-libs/libgcrypt
        dev-libs/libxml2
"
RDEPEND="$DEPEND"

S="${WORKDIR}/${PN}-r${PV}"

TDEDIR="/opt/trinity"


src_unpack() {
	unpack ${PN}-r${PV}.tar.gz
	unpack php_manual_en_20030401.tar.bz2
	cd ${S}
	unpack css.tar.bz2
	unpack javascript.tar.bz2
	unpack html.tar.bz2
}

src_configure() {
	cp -rf ${TDEDIR}/share/cmake .
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=:/opt/trinity/$(get_libdir)/pkgconfig
	export QTDIR=$TQT
	mycmakeargs=(
		-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
		-DCMAKE_SKIP_RPATH=OFF
		-DCMAKE_INSTALL_RPATH="${TDEDIR}/$(get_libdir)"
#		-DCMAKE_NO_BUILTIN_CHRPATH=ON
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCMAKE_PROGRAM_PATH="${TDEDIR}/bin"
		-DWITH_GCC_VISIBILITY=OFF
		-DCMAKE_INSTALL_PREFIX=${TDEDIR}
		-DBIN_INSTALL_DIR="${TDEDIR}/bin"
		-DCONFIG_INSTALL_DIR="/etc/trinity"
		-DINCLUDE_INSTALL_DIR="${TDEDIR}/include"
		-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
		-DSHARE_INSTALL_PREFIX="${TDEDIR}/share"
		-DBUILD_ALL=ON
)
	cmake-utils_src_configure
}


src_install() {
	dodir ${TDEDIR}/share/apps/quanta/doc
	for i in css html javascript ; do
	pushd $i
	./install.sh <<EOF
${D}/${TDEDIR}/share/apps/quanta/doc
EOF
	popd
	rm -rf $i
	done
	cp -a ${WORKDIR}/php ${WORKDIR}/php.docrc ${D}/${TDEDIR}/share/apps/quanta/doc
	cmake-utils_src_install
}
