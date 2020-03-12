# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

inherit eutils desktop flag-o-matic gnome2-utils

DESCRIPTION="The package for web developpment"
HOMEPAGE="http://trinitydesktop.org/"

if [[ ${PV} = 14.0.999 ]]; then
	inherit git-r3
        EGIT_REPO_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}"
        EGIT_BRANCH="r14.0.x"
	EGIT_SUBMODULES=()
	SRC_URI="http://download.sourceforge.net/quanta/html.tar.bz2
	http://download.sourceforge.net/quanta/css.tar.bz2
	http://download.sourceforge.net/quanta/javascript.tar.bz2
	http://download.sourceforge.net/quanta/php_manual_en_20030401.tar.bz2"
elif [[ ${PV} = 9999 ]]; then
	inherit git-r3
        EGIT_REPO_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}"
	EGIT_SUBMODULES=()
	SRC_URI="http://download.sourceforge.net/quanta/html.tar.bz2
	http://download.sourceforge.net/quanta/css.tar.bz2
	http://download.sourceforge.net/quanta/javascript.tar.bz2
	http://download.sourceforge.net/quanta/php_manual_en_20030401.tar.bz2"
else
	SRC_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz
	http://download.sourceforge.net/quanta/html.tar.bz2
	http://download.sourceforge.net/quanta/css.tar.bz2
	http://download.sourceforge.net/quanta/javascript.tar.bz2
	http://download.sourceforge.net/quanta/php_manual_en_20030401.tar.bz2"
fi

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

BDEPEND="
	sys-devel/autoconf
	sys-devel/automake
	virtual/pkgconfig
	sys-devel/gettext
	sys-devel/libtool
	trinity-base/tde-common-admin
	trinity-base/tde-common-cmake
"
DEPEND="
	>=trinity-base/tdelibs-${PV}
        trinity-base/tdesdk
        dev-libs/libxslt
        dev-libs/libgcrypt
        dev-libs/libxml2
	app-text/htmltidy
"
RDEPEND="$DEPEND"

if [[ ${PV} = 14.0.999 ]] || [[ ${PV} = 9999 ]]; then
	S="${WORKDIR}/${P}"
else
	S="${WORKDIR}/${PN}-r${PV}"
fi

TDEDIR="/opt/trinity"

src_unpack() {
	if [[ ${PV} = 14.0.999 ]] || [[ ${PV} = 9999 ]]; then
		git-r3_src_unpack
	else
		unpack ${PN}-r${PV}.tar.gz
	fi
	unpack php_manual_en_20030401.tar.bz2
	cd ${S}
	unpack css.tar.bz2
	unpack javascript.tar.bz2
	unpack html.tar.bz2
}

src_prepare() {
	cp -rf ${TDEDIR}/share/cmake ${S}/
	cp -rf /opt/trinity/share/tde/admin ${S}/
	cd ${S}/admin
	libtoolize -c
	cp -Rp /usr/share/aclocal/libtool.m4 "${S}/admin/libtool.m4.in"
	default
}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export CXXFLAGS="${CXXFLAGS} -std=c++11"
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${TDEDIR}/$(get_libdir)/pkgconfig
	emake -f admin/Makefile.common
	build_arts=no ./configure --prefix="${TDEDIR}" \
		--without-arts \
		--bindir="${TDEDIR}/bin" \
		--datadir="${TDEDIR}/share" \
		--includedir="${TDEDIR}/include" \
		--libdir="${TDEDIR}/$(get_libdir)" \
		--disable-dependency-tracking \
		--disable-debug \
		--enable-new-ldflags \
		--enable-final \
		--enable-closure \
		--enable-rpath

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
	emake install DESTDIR="${D}"
}
