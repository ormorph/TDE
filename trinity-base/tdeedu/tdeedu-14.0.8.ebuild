# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

inherit eutils desktop flag-o-matic cmake-utils gnome2-utils

DESCRIPTION="TDE Education Project "
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

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
SLOT="0"
IUSE="-arts -ocaml -python"

BDEPEND="
	ocaml? ( dev-lang/ocaml
		dev-ml/facile )
	~trinity-base/tde-common-cmake-${PV}
	sys-devel/autoconf
	sys-devel/gettext
	sys-devel/automake
	sys-devel/libtool
	sys-devel/m4
"

DEPEND="
	dev-util/desktop-file-utils
	app-misc/fdupes
	python? ( dev-libs/boost[python] )
	~trinity-base/tdelibs-${PV}
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
	cp -rf ${TDEDIR}/share/cmake .
	sed '/scripting/d' -i kig/CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${TDEDIR}/$(get_libdir)/pkgconfig
	mycmakeargs=(
	-DCMAKE_INSTALL_PREFIX=${TDEDIR}
	-DCMAKE_INSTALL_RPATH="${TDEDIR}/$(get_libdir)"
	-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
	-DWITH_GCC_VISIBILITY=OFF
	-DWITH_OCAML_SOLVER=$(usex ocaml ON OFF )
	-DWITH_ARTS=$(usex arts ON OFF )
	-DWITH_KIG_PYTHON_SCRIPTING=$(usex python ON OFF )
	-DWITH_ALL_OPTIONS=ON
	-DBUILD_ALL=ON
	)
	cmake-utils_src_configure
}
