# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"
: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
TDE_L10N="af ar az be bg bn br bs ca cs csb cy da de el en_GB eo es et 
eu fa fi fr fy ga gl he hi hr hu is it ja kk km ko lt lv mk mn ms 
nb nds nl nn pa pl pt pt_BR ro ru rw se sk sl sr sr@Latn ss sv ta te 
tg th tr uk uz uz@cyrillic vi wa zh_CN zh_TW"

inherit eutils desktop flag-o-matic gnome2-utils cmake-utils


DESCRIPTION=""
HOMEPAGE="http://trinitydesktop.org/"
VER="r14.0.x"

SRC_URI="https://git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

DEPEND="
	trinity-base/tde-common-cmake
	trinity-base/tdebase"
RDEPEND="${RDEPEND}"



for X in ${TDE_L10N} ; do
	IUSE+=" -l10n_${X}"
done

S="${WORKDIR}/${PN}-r${PV}"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

pkg_setup() {
	if [[ "$ARCH" == "amd64" ]]; then
		export LIBDIRSUFFIX="64"
	else
		export LIBDIRSUFFIX=""
	fi
}

src_prepare() {
	cp -rf ${TDEDIR}/share/cmake ${S}
	eapply_user
}

tde_build() {
	CMAKE_USE_DIR="${S}/${dir}"
        BUILD_DIR="${WORKDIR}/${dir}-build"
}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	PREFIX="${TDEDIR}"
	for lang in ${L10N}; do
		dir="tde-i18n-$lang"
		einfo "Configuring tde-i18n-$dir"
		if [ -d "${S}/${dir}" ]; then
			tde_build
			mycmakeargs=(-DCMAKE_BUILD_TYPE="RelWithDebInfo"
			-DCMAKE_VERBOSE_MAKEFILE=ON
			-DCMAKE_INSTALL_PREFIX="${TDEDIR}"
			-DBIN_INSTALL_DIR="${TDEDIR}/bin"
			-DINCLUDE_INSTALL_DIR="${TDEDIR}/include"
			-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)"
			-DPKGCONFIG_INSTALL_DIR="${TDEDIR}/$(get_libdir)/pkgconfig"
			-DSHARE_INSTALL_PREFIX="${TDEDIR}/share"
			-DBUILD_ALL=ON
			-DBUILD_DOC=ON
			-DBUILD_DATA=ON
			-DBUILD_MESSAGES=ON)
			cmake-utils_src_configure
		fi
	done
}

src_compile() {
	for lang in ${L10N}; do
		dir="${PN}-$lang"
                einfo "Configuring tde-i18n-$dir"
                if [ -d "${S}/${dir}" ]; then
			tde_build
			cmake-utils_src_compile
                fi
	done

}

src_install() {
	for lang in ${L10N}; do
		dir="${PN}-$lang"
                einfo "Configuring tde-i18n-$dir"
                if [ -d "${S}/${dir}" ]; then
			cd "${S}/${dir}"/build
			cmake-utils_src_install
		fi
	done
}
