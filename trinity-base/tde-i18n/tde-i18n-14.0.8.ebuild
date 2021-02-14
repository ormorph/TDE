# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

TDE_L10N="af ar az be bg bn br bs ca cs csb cy da de el en_GB eo es et 
eu fa fi fr fy ga gl he hi hr hu is it ja kk km ko lt lv mk mn ms 
nb nds nl nn pa pl pt pt_BR ro ru rw se sk sl sr sr@Latn ss sv ta te 
tg th tr uk uz uz@cyrillic vi wa zh_CN zh_TW"

inherit eutils desktop flag-o-matic gnome2-utils


DESCRIPTION=""
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
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""
SLOT="0"

DEPEND="~trinity-base/tdelibs-${PV}
	trinity-base/tde-common-cmake"
RDEPEND="${DEPEND}"



for X in ${TDE_L10N} ; do
	IUSE+=" -l10n_${X}"
done

if [[ ${PV} = 14.0.999 ]] || [[ ${PV} = 9999 ]]; then
	S="${WORKDIR}/${P}"
else
	S="${WORKDIR}/${PN}-r${PV}"
fi

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

src_configure() {
	cp -rf ${TDEDIR}/share/cmake .
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	PREFIX="${TDEDIR}"
	for dir in ${L10N}; do
		einfo "Configuring tde-i18n-$dir"
		if [ -d "${S}/tde-i18n-${dir}" ]; then
			cd "${S}/tde-i18n-${dir}"
			rm CMakeCache.txt
			mkdir build
			cd build
			cmake "${S}/tde-i18n-${dir}" \
			-DCMAKE_BUILD_TYPE="RelWithDebInfo" \
			-DCMAKE_VERBOSE_MAKEFILE=ON \
			\
			-DCMAKE_INSTALL_PREFIX="${TDEDIR}" \
			-DBIN_INSTALL_DIR="${TDEDIR}/bin" \
			-DINCLUDE_INSTALL_DIR="${TDEDIR}/include" \
			-DLIB_INSTALL_DIR="${TDEDIR}/$(get_libdir)" \
			-DPKGCONFIG_INSTALL_DIR="${TDEDIR}/$(get_libdir)/pkgconfig" \
			-DSHARE_INSTALL_PREFIX="${TDEDIR}/share" \
			\
			-DBUILD_ALL=ON \
			-DBUILD_DOC=ON \
			-DBUILD_DATA=ON \
			-DBUILD_MESSAGES=ON || die
		fi
	done
}

src_compile() {
	for dir in ${L10N}; do
                einfo "Configuring tde-i18n-$dir"
                if [ -d "${S}/tde-i18n-${dir}" ]; then
                        cd "${S}/tde-i18n-${dir}"/build
                        emake || die
                fi
	done

}

src_install() {
	for dir in ${L10N}; do
                einfo "Configuring tde-i18n-$dir"
                if [ -d "${S}/tde-i18n-${dir}" ]; then
			cd "${S}/tde-i18n-${dir}"/build
			emake install DESTDIR=${D} || die
		fi
	done
}
