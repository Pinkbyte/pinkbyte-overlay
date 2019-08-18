# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib pax-utils rpm

MAJOR_V=$(ver_cut 1-2)
MINOR_V=$(ver_cut 4)

DESCRIPTION="NetUP UTM - universal billing system for Internet Service Providers"
HOMEPAGE="https://www.netup.tv/en/utm5/"
SRC_URI="${PN}-${MAJOR_V}.x86_64-centos6_x64(update${MINOR_V}).rpm"

LICENSE="NETUP"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="fetch mirror strip"

RDEPEND="
	app-crypt/mit-krb5
	dev-db/postgresql:*
	dev-libs/libxml2:2
	dev-libs/libxslt
	dev-libs/openssl:0
	net-misc/curl
	sys-libs/zlib
	virtual/libmysqlclient
	virtual/mailx
"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download ${A} from:"
	einfo "http://www.netup.ru/"
	einfo "and move it to ${DISTDIR}"
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

	# Mysql library(libmysqlclient_r.so.16) should be fetched from CentOS 6. Current version in Gentoo is incompatible

	doinitd "${FILESDIR}"/utm5_{core,radius,rfw}
	doconfd "${FILESDIR}"/utm5_rfw.conf

	# Prune libtool files
	find "${D}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	echo
	if [ -z "${REPLACING_VERSIONS}" ] ; then
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
