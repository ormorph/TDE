# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="6"

TDE_L10N="bg ca cs cy da de el en_GB es et eu fa fi fr ga gl hu it ja km \
lv ms nb nds ne nl pl pt pt_BR ru sk sl sr sr@Latn sv tr uk zh_CN zh_TW"

inherit eutils desktop flag-o-matic gnome2-utils


DESCRIPTION="Koffice language pack"
HOMEPAGE="http://trinitydesktop.org/"

SRC_URI="https://git.trinitydesktop.org/cgit/${PN}/snapshot/${PN}-r${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

DEPEND="
	trinity-base/tde-common-admin
	dev-qt/tqtinterface
	trinity-base/tdelibs
"
RDEPEND="${RDEPEND}"

for X in ${TDE_L10N} ; do
        IUSE+=" -l10n_${X}"
done

S="${WORKDIR}/${PN}-r${PV}"

TQT="/opt/trinity"
TDEDIR="/opt/trinity"

src_prepare() {
	cp -rf ${TDEDIR}/share/tde/admin ${S}/
	cd ${S}/admin
        libtoolize -c
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
			build_arts=no ./configure --without-arts \
				--prefix=${PREFIX} \
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
