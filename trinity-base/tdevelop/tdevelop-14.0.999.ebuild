# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

inherit cmake-utils desktop flag-o-matic gnome2-utils

DESCRIPTION="The TDevelop Integrated Development Environment"
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
SLOT="0"
IUSE=""

BDEPEND="
	trinity-base/tde-common-cmake
	sys-devel/libtool
	app-misc/fdupes
	dev-util/desktop-file-utils
"
DEPEND="
	dev-qt/tqt3
	trinity-base/tdelibs
	trinity-base/tdebase
	trinity-base/tdesdk
	dev-lang/perl
	sys-devel/gettext
	dev-util/ctags
	sys-devel/flex
	dev-libs/libgamin
	net-dns/libidn
	virtual/acl
	dev-libs/openssl
	net-nds/openldap
	sys-libs/db
"
RDEPEND="$DEPEND"

if [[ ${PV} = 14.0.999 ]] || [[ ${PV} = 9999 ]]; then
	S="${WORKDIR}/${P}"
else
	S="${WORKDIR}/${PN}-r${PV}"
fi

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

src_prepare() {
	cp -rf ${TDEDIR}/share/tde/admin ${S}/parts/appwizard/common/ || die
	cd ${S}/parts/appwizard/common/admin
	libtoolize -c
	cp -Rp /usr/share/aclocal/libtool.m4 libtool.m4.in
	cmake-utils_src_prepare
}

src_configure() {
	cp -rf ${TDEDIR}/share/cmake ${S}/
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=/opt/trinity/lib/pkgconfig
	mycmakeargs=(
	-DCMAKE_INSTALL_PREFIX=${TDEDIR}
	-DCMAKE_BUILD_TYPE="RelWithDebInfo"
	-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
	-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG -L${TDEDIR}/$(get_libdir)"
	-DCMAKE_SKIP_RPATH=OFF
	-DCMAKE_INSTALL_RPATH="${TDEDIR}/$(get_libdir)"
#	-DCMAKE_NO_BUILTIN_CHRPATH=ON
	-DCMAKE_VERBOSE_MAKEFILE=ON
	-DWITH_GCC_VISIBILITY=OFF
	-DBIN_INSTALL_DIR="${TDEDIR}/bin"
	-DCONFIG_INSTALL_DIR="/etc/trinity"
	-DINCLUDE_INSTALL_DIR="${TDEDIR}/include"
	-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
	-DSHARE_INSTALL_PREFIX="${TDEDIR}/share"
	-DWITH_BUILDTOOL_ALL=ON
	-DWITH_LANGUAGE_ALL=ON
	-DWITH_VCS_ALL=OFF
	-DBUILD_ALL=ON
	)

	 cmake-utils_src_configure
}
