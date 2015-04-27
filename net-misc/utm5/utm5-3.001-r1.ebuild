# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils multilib pax-utils rpm

DESCRIPTION="NetUP UTM - universal billing system for Internet Service Providers."
HOMEPAGE="www.netup.ru"
SRC_URI="
	amd64? ( ${P}.x86_64-centos6_x64.rpm )
	x86? ( ${P}.i386-centos6.rpm )
"

LICENSE="NETUP"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="fetch mirror strip"

RDEPEND="
	dev-libs/openssl:0
	sys-libs/zlib
	dev-libs/libxslt
	virtual/mailx
	dev-db/mysql
	dev-db/postgresql
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
	for conf in *.cfg
	do
		doins ${conf}
		rm ${conf} || die
		dosym /etc/utm5/${conf} /netup/utm5/${conf}
	done
	popd &>/dev/null
	# Preserve permissions! Replace with doins with care!
	cp -a netup "${D}" || die
	pax-mark -m "${D}/netup/utm5/bin/utm5_core"

	dosym /usr/$(get_libdir)/libssl.so /netup/utm5/lib/libssl.so.10
	dosym /usr/$(get_libdir)/libcrypto.so /netup/utm5/lib/libcrypto.so.10
	dosym /usr/$(get_libdir)/libmysqlclient_r.so /netup/utm5/lib/libmysqlclient_r.so.16

	doinitd "${FILESDIR}"/utm5_{core,radius,rfw}
	doconfd "${FILESDIR}"/utm5_rfw.conf

	prune_libtool_files
}

pkg_postinst() {
	echo
	if [ -f "${PREVIOUS_INSTALLED}" ] ; then
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
	ewarn "Note: Configuration files are in /etc/utm5"
}
