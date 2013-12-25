# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils pax-utils

DESCRIPTION="NetUP UTM - universal billing system for Internet Service Providers."
HOMEPAGE="www.netup.ru"
SRC_URI="${P}.tar.bz2"

LICENSE="NETUP"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="fetch mirror strip"

X86_RDEPEND="
	dev-libs/openssl:0.9.8
	sys-libs/zlib
	dev-libs/libxslt
"

AMD64_RDEPEND="
	app-emulation/emul-linux-x86-baselibs
"

RDEPEND="
	amd64?  ( ${AMD64_RDEPEND} )
	x86? ( ${X86_RDEPEND} )
	virtual/mailx
	|| ( dev-db/mysql
	dev-db/postgresql )
"

S="${WORKDIR}"

PREVIOUS_INSTALLED="${T}/previous_installed"

pkg_nofetch() {
	einfo "Please download ${A} from:"
	einfo "http://www.netup.ru/"
	einfo "and move it to ${DISTDIR}"
}

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

	if [ -x /netup/utm5/bin/utm5_core ] ; then
		einfo "Previous installation found."
		echo "true" > "${PREVIOUS_INSTALLED}"
	fi
}

src_install() {
	dodir /netup/utm5
	keepdir /netup/utm5/backup
	keepdir /netup/utm5/db
	keepdir /netup/utm5/log
	keepdir /netup/utm5/templates

	insinto /etc/utm5
	pushd netup/utm5 &>/dev/null || die
	for conf in radius5.cfg rfw5.cfg utm5.cfg
	do
# Pinkbyte: 5.2.1-009 does not ship default configs!
#		doins ${conf}
#		rm ${conf} || die
		dosym /etc/utm5/${conf} /netup/utm5/${conf}
	done
	popd &>/dev/null
	# Preserve permissions! Replace with doins with care!
	cp -a netup "${D}" || die
	pax-mark -m /netup/utm5/bin/utm5_core

	doinitd "${FILESDIR}"/utm5_{core,radius,rfw}
	doconfd "${FILESDIR}"/utm5_rfw.conf

	prune_libtool_files
}

pkg_postinst() {
	echo
	if [ -f "${PREVIOUS_INSTALLED}" ] ; then
		elog "If this is your first instalation of utm5 please run:"
		elog "mysqladmin create UTM5"
		elog "mysql UTM5 < /netup/utm5/UTM5_MYSQL.sql"
		elog "mysql UTM5 < your_reg_file.sql"
		elog "to initialise mysql database. Or"
		elog "createdb -U postgres UTM5"
		elog "psql UTM5 < /netup/utm5/UTM5_MYSQL.sql"
		elog "psql UTM5 < your_reg_file.sql"
		elog "to initialise postgresql database."
	else
		elog "Now, please, update your database with command"
		elog "mysql -f UTM5 < /netup/utm5/UTM5_MYSQL_update.sql"
		elog "if you are using mysql database or"
		elog "psql -f /netup/utm5/UTM5_PG_update.sql UTM5"
		elog "if you are using postgresql."
		elog ""
		elog "Please note. You need to update your UTM5_Admin.jar also."
	fi
	echo
	einfo "To start utm5_core automaticaly during booting you need to run:"
	einfo "rc-update add utm5_core default"
	echo
	ewarn "Note: Configuration files are in /etc/utm5"
}
