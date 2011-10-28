# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="NetUP UTM - universal billing system for Internet Service Providers."
HOMEPAGE="www.netup.ru"
SRC_URI="${P}.tar.bz2"

LICENSE="NETUP"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RESTRICT="fetch nostrip"

RDEPEND="virtual/libc
		dev-libs/openssl
		sys-libs/zlib
		dev-libs/libxslt
		|| ( dev-db/mysql
		dev-db/postgresql )"

pkg_nofetch() {
	einfo "Please download ${A} from:"
	einfo "http://www.netup.ru/"
	einfo "and move it to ${DISTDIR}"
}

PREVIOUS_INSTALLED="${T}/previous_installed"

pkg_setup() {

	for process in utm5_radius utm5_rfw utm5_core
	do
		if `ps aux | grep -v "grep ${process}" | grep ${process} >/dev/null 2>&1` ; then
			ewarn "You did not stop ${process}."
			ewarn "Please stop all process with ${process} in"
			ewarn "their names and then try again."
			die "Processes are not stoped."
		fi
	done

	echo "false" > ${PREVIOUS_INSTALLED}

	if [ -x /netup/utm5/bin/utm5_core ] ; then
		einfo "Previous installation found."
		echo "true" > ${PREVIOUS_INSTALLED}
	fi
}

src_install() {
	cd ${WORKDIR}
	cp -a usr ${D} || die "install failed"
	dodir /etc/utm5
	dodir /netup/utm5
	keepdir /netup/utm5/backup
	keepdir /netup/utm5/db
	keepdir /netup/utm5/log
	keepdir /netup/utm5/templates

	for conf in utm5.cfg radius5.cfg rfw5.cfg web5.cfg
	do
		if [ -x netup/utm5/${conf} ] ; then
			chmod ugo-x netup/utm5/${conf}
		fi
		mv netup/utm5/${conf} ${D}/etc/utm5/
		dosym /etc/utm5/${conf} /netup/utm5/${conf}
	done
	cp -a netup ${D}

	doinitd ${FILESDIR}/utm5_core ${FILESDIR}/utm5_radius ${FILESDIR}/utm5_rfw
	doconfd ${FILESDIR}/utm5_rfw.conf
}

pkg_postinst() {
	echo
	if [ "`cat $PREVIOUS_INSTALLED`" = "false" ] ; then
		einfo "If this is your first instalation of utm5 please run:"
		einfo "mysqladmin create UTM5"
		einfo "mysql UTM5 < /netup/utm5/UTM5_MYSQL.sql"
		einfo "mysql UTM5 < your_reg_file.sql"
		einfo "to initialise mysql database. Or"
		einfo "createdb -U postgres UTM5"
		einfo "psql UTM5 < /netup/utm5/UTM5_MYSQL.sql"
		einfo "psql UTM5 < your_reg_file.sql"
		einfo "to initialise postgresql database."
	else
		einfo "Now, please, update your database with command"
		einfo "mysql -f UTM5 < /netup/utm5/UTM5_MYSQL_update.sql"
		einfo "if you are using mysql database or"
		einfo "psql -f /netup/utm5/UTM5_PG_update.sql UTM5"
		einfo "if you are using postgresql."
		einfo ""
		einfo "Please note. You need to update your UTM5_Admin.jar also."
	fi
	echo
	einfo "To start utm5_core automaticaly during booting you need to run:"
	einfo "rc-update add utm5_core default"
	echo
	ewarn "Note: Configuration files are in /etc/utm5."
	echo
	einfo "Thank you for choosing utm5."
}
