# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="This is the Trolltech TQt library, version 3"
HOMEPAGE="http://trinitydesktop.org/"


SRC_URI="http://mirror.ppa.trinitydesktop.org/trinity/releases/R${PV}/dependencies/${PN}-R${PV}.tar.bz2"

LICENSE="GPL2+"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="+cups debug doc examples firebird +ipv6 mysql nas nis +opengl postgres +sqlite xinerama"

RDEPEND="
	virtual/jpeg:0
	media-libs/freetype
	media-libs/libmng
	media-libs/libpng:0
	sys-libs/zlib
	x11-libs/libXft
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libSM
	dev-lang/perl
	media-libs/giflib
	media-libs/fontconfig
	dev-util/desktop-file-utils
	sys-devel/make
	sys-apps/sed
	sys-apps/findutils
	app-arch/tar
	dev-libs/glib:2
	sys-fs/e2fsprogs
	sys-apps/util-linux
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libICE
	x11-libs/libXt
	x11-libs/libXmu
	x11-libs/libXi
	net-libs/libnsl
	net-libs/libtirpc
	cups? ( net-print/cups )
	firebird? ( dev-db/firebird )
	mysql? ( virtual/mysql )
	nas? ( media-libs/nas )
	opengl? ( virtual/opengl virtual/glu media-libs/mesa )
	postgres? ( dev-db/postgresql:= )
	xinerama? ( x11-libs/libXinerama )
	sqlite? ( dev-db/sqlite )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"

S="${WORKDIR}/dependencies/${PN}"


TQTBASE="/opt/trinity"

pkg_setup() {
	export SYSCONFDIR=${D}/etc/trinity

	if [[ "$ARCH" == "amd64" ]]; then
		export PLATFORM="linux-g++-64"
	else
		export PLATFORM="linux-g++"
	fi
}

src_prepare() {

sed -i ${S}/mkspecs/*/qmake.conf \
  -e "s|^QMAKE_CFLAGS		=.*|QMAKE_CFLAGS		= ${CFLAGS}|" \

	eapply_user
}

src_configure() {
	unset TDE_FULL_SESSION TDEROOTHOME TDE_SESSION_UID TDEHOME TDE_MULTIHEAD
	#export SYSCONF="${D}${TQTBASE}"/etc/settings
	export LD_LIBRARY_PATH={$LD_LIBRARY_PATH}:${S}/lib

	# common opts
	myconf=( -thread -libdir ${TQTBASE}/$(get_libdir) -sysconfdir ${SYSCONFDIR}
	-shared -fast -no-exceptions
	-platform ${PLATFORM}
	-no-pch
	-stl
	-sm
	-xshape
	-xcursor
	-xrandr
	-xrender
	-xft
	-tablet
	-xkb
	-system-zlib
	-system-libjpeg -system-libmng -system-libpng
	-qt-imgfmt-jpeg -qt-imgfmt-mng -qt-imgfmt-png
	-xft -prefix ${TQTBASE}
	-fast -no-sql-odbc
	-I/usr/include/tirpc -plugin-style-cde
	-plugin-style-compact
	-plugin-style-motifplus
	-plugin-style-platinum
	-plugin-style-sgi
	-plugin-style-windows
	-plugin-imgfmt-mng
	-qt-style-motif
	-xkb -xshape -inputmethod -lfontconfig
	-inputmethod-ext
	-dlopen-opengl
	-system-zlib -qt-gif)
	use nas		&& myconf+=(-system-nas-sound)
	use nis		&& myconf+=(-nis) || myconf+=(-no-nis)
	use mysql	&& myconf+=(-plugin-sql-mysql -I/usr/include/mysql -L/usr/$(get_libdir)/mysql) || myconf+=(-no-sql-mysql)
	use postgres	&& myconf+=(-plugin-sql-psql -I/usr/include/postgresql/server -I/usr/include/postgresql/pgsql -I/usr/include/postgresql/pgsql/server) || myconf+=(-no-sql-psql)
	use firebird    && myconf+=(-plugin-sql-ibase -I/opt/firebird/include) || myconf+=(-no-sql-ibase)
	use sqlite	&& myconf+=(-plugin-sql-sqlite) || myconf+=(-no-sql-sqlite)
	use cups	&& myconf+=(-cups) || myconf+=(-no-cups)
	use opengl	&& myconf+=(-enable-module=opengl) || myconf+=(-disable-opengl)
	use debug	&& myconf+=(-debug) || myconf+=(-release -no-g++-exceptions)
	use xinerama && myconf+=(-xinerama) || myconf+=(-no-xinerama)
	use ipv6 && myconf+=(-ipv6) || myconf+=(-no-ipv6)



	./configure ${myconf[@]} || die
}


src_install() {
	emake INSTALL_ROOT="${D}" install

	#dodir /usr/$(get_libdir)
	#mv "${D}${TQTBASE}/$(get_libdir)/pkgconfig" "${D}/usr/$(get_libdir)/"

	# cleanup a bad symlink created by crappy install scrypt
	#rm -r "${D}${TQTBASE}/mkspec/${PLATFORM}/${PLATFORM}"

	# List all the multilib libdirs
#	local libdirs
#	for alibdir in $(get_all_libdirs); do
#		libdirs="${libdirs}:${TQTBASE}/${alibdir}"
#	done

	# environment variables
	cat <<EOF > "${T}"/44tqt3
PATH="${TQTBASE}/bin"
ROOTPATH="${TQTBASE}/bin"
LDPATH="${libdirs:1}"
MANPATH="${TQTBASE}/doc/man"
EOF

	cat <<EOF > "${T}"/44-tqt3-revdep
SEARCH_DIRS="${TQTBASE}"
EOF

	insinto /etc/revdep-rebuild
	doins "${T}"/44-tqt3-revdep
	doenvd "${T}"/44tqt3

	if [ "${SYMLINK_LIB}" = "yes" ]; then
		dosym $(get_abi_LIBDIR ${DEFAULT_ABI}) ${TQTBASE}/lib
	fi

	keepdir /etc/trinity/setting

#	if use doc; then
#		insinto ${TQTBASE}
#		doins -r "${S}"/doc
#	fi

#	if use examples; then
#		find "${S}"/examples "${S}"/tutorial -name Makefile | \
#			xargs sed -i -e "s:${S}:${TQTBASE}:g"

#		cp -r "${S}"/examples "${D}"${TQTBASE}/
#		cp -r "${S}"/tutorial "${D}"${TQTBASE}/
#	fi


	sed -e "s:${S}:${TQTBASE}:g" \
		"${S}"/.qmake.cache > "${D}"${TQTBASE}/.qmake.cache

	dodoc FAQ README README-QT.TXT changes*
}
