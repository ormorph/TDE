# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"


inherit eutils desktop flag-o-matic gnome2-utils


DESCRIPTION="aRts, the Trinity sound (and all-around multimedia) server/output manager"
HOMEPAGE="http://trinitydesktop.org/"

if [[ ${PV} = 14.0.999 ]]; then
	inherit git-r3
        EGIT_REPO_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}"
        EGIT_BRANCH="r14.0.x"
	EGIT_SUBMODULES=()
elif [[ ${PV} = 9999 ]]; then
	inherit git-r3
        EGIT_REPO_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}"
	EGIT_SUBMODULES=()
else
	SRC_URI="https://mirror.git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"
fi

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+lcms +bzip2 +paper +ruby +freetype +png +utempter +graphicsmagick +postgres +wpd +wv2 +opengl +xi +sqlite -arts"
SLOT="0"

DEPEND="
	trinity-base/tde-common-admin
	>=dev-qt/tqtinterface-${PV}
	~trinity-base/tdelibs-${PV}
	~trinity-apps/koffice-i18n-${PV}
	~trinity-base/tdegraphics-${PV}
	sys-devel/autoconf
	sys-devel/automake
	sys-devel/libtool
	virtual/pkgconfig
	media-libs/fontconfig
	media-libs/libart_lgpl
	media-libs/libjpeg-turbo
	virtual/imagemagick-tools[tiff]
	sys-libs/zlib
	dev-libs/openssl
	dev-lang/python
	dev-libs/libpcre
	sys-devel/gettext
	virtual/mysql
	dev-lang/perl
	app-doc/doxygen
	app-text/aspell
	dev-libs/libxslt
	media-libs/openexr
	media-libs/libexif
	sys-libs/readline
	lcms? ( trinity-apps/lcms )
	bzip2? ( app-arch/bzip2 )
	paper? ( app-text/libpaper )
	ruby? ( dev-lang/ruby )
	freetype? ( media-libs/freetype )
	png? ( media-libs/libpng )
	graphicsmagick? ( media-gfx/graphicsmagick )
	utempter? ( sys-libs/libutempter )
	postgres? ( dev-db/postgresql 
		dev-libs/libpqxx )
	wpd? ( app-text/libwpd )
	wv2? ( app-text/wv2 )
	opengl? ( media-libs/mesa 
		virtual/glu )
	xi? ( x11-libs/libXi )
	sqlite? ( dev-db/sqlite )
"
RDEPEND="${DEPEND}"

if [[ ${PV} = 14.0.999 ]] || [[ ${PV} = 9999 ]]; then
	S="${WORKDIR}/${P}"
else
	S="${WORKDIR}/${PN}-r${PV}"
fi

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

src_prepare() {
	cp -rf ${TDEDIR}/share/tde/admin ${S}/ || die
	cd ${S}/admin
	libtoolize -c
        cp -Rp /usr/share/aclocal/libtool.m4 "${S}/admin/libtool.m4.in"
	sed -i "${S}/kexi/migration/keximigratetest.cpp" \
       -e "/TDEApplication/ s|\");|\", true, true, true);|"
	if ! use arts ; then
	   sed -i "s/-lsoundserver_idl -lmcop//" ${S}/kpresenter/Makefile.am
	fi
        eapply_user
}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export CXXFLAGS="$CXXFLAGS -std=c++11"
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/trinity/$(get_libdir)/pkgconfig
	emake -f admin/Makefile.common

	myconf=(--prefix=${TDEDIR} --libdir=${TDEDIR}/$(get_libdir)
		--includedir=${TDEDIR}/include
		--disable-dependency-tracking
		--disable-debug
		--enable-new-ldflags
		--enable-final
		--enable-closure
		--enable-rpath
		--disable-gcc-hidden-visibility
		--with-extra-libs=${TDEDIR}/$(get_libdir)
		--with-extra-includes=${TDEDIR}/include/arts
		--disable-kexi-macros
		--disable-scripting)
		use postgres && myconf+=(--enable-pgsql)|| myconf+=(--disable-pgsql)
	if use arts ; then
		./configure ${myconf[@]} || die
	else
		build_arts=no ./configure --without-arts ${myconf[@]} || die
	fi
	sed 's#-std=c++11#-std=c++98#' -i ${S}/filters/kspread/qpro/libqpro/src/Makefile 
}
