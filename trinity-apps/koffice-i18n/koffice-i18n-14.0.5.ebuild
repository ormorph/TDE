# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

TDE_L10N="bg ca cs cy da de el en_GB es et eu fa fi fr ga gl hu it ja km \
lv ms nb nds ne nl pl pt pt_BR ru sk sl sr sr@Latn sv tr uk zh_CN zh_TW"

inherit eutils desktop flag-o-matic gnome2-utils


DESCRIPTION="Koffice language pack"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/applications/${PN}-R${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

DEPEND="
	dev-qt/tqtinterface
	trinity-base/tdelibs
"
RDEPEND="${RDEPEND}"

for X in ${TDE_L10N} ; do
        IUSE+=" -l10n_${X}"
done

S="${WORKDIR}/applications/${PN}"

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
        cp /usr/share/libtool/build-aux/ltmain.sh "${S}/admin/ltmain.sh"
        cp -Rp /usr/share/aclocal/libtool.m4 "${S}/admin/libtool.m4.in"
        eapply_user
}

src_configure() {
        unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
        PREFIX="${TDEDIR}"
	for dir in ${L10N}; do
		einfo "Configuring koffice-i18n-${dir}"
		if [ -d "${S}/koffice-i18n-${dir}" ]; then
			cd "${S}/koffice-i18n-${dir}"
			emake -f admin/Makefile.common
			./configure --prefix=${PREFIX} \
				--sysconfdir=/etc/tinity
		fi
        done
}

src_compile() {
	PREFIX="${TDEDIR}"
	for dir in ${L10N}; do
		einfo "Configuring koffice-i18n-${dir}"
		if [ -d "${S}/koffice-i18n-${dir}" ]; then
			cd "${S}/koffice-i18n-${dir}"
			emake
		fi
	done
}

src_install() {
	PREFIX="${TDEDIR}"
	for dir in ${L10N}; do
		einfo "Configuring koffice-i18n-${dir}"
		if [ -d "${S}/koffice-i18n-${dir}" ]; then
			cd "${S}/koffice-i18n-${dir}"
			emake install DESTDIR=${D}
		fi
	done

}
