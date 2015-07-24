# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils systemd user

DESCRIPTION="Lite and fast log analyzer for Squid"
HOMEPAGE="http://lightsquid.sourceforge.net/"
SRC_URI="mirror://sourceforge/lightsquid/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="net-proxy/squid
	dev-perl/GD[gif,truetype]
	dev-perl/CGI"
DEPEND=""

pkg_setup() {
	enewuser lightsquid -1 -1 /var/lib/lightsquid squid
}

src_prepare() {
	sed -i \
		-e '/^$cfgpath/s:/var/www/html/lightsquid:/etc/lightsquid:' \
		-e '/^$tplpath/s:/var/www/html/lightsquid/tpl:/usr/share/lightsquid/tpl:' \
		-e '/^$langpath/s:/var/www/html/lightsquid/lang:/usr/share/lightsquid/lang:' \
		-e '/^$reportpath/s:/var/www/html/lightsquid/report:/var/lib/lightsquid:' \
		-e '/^$ip2namepath/s:/var/www/html/lightsquid/ip2name:/etc/lightsquid/ip2name:' \
		-e '/^$lockpath/s:/var/lock/lightsquid:/run/lock/lightsquid:' \
		lightsquid.cfg || die 'can not change lightsquid.cfg'

	sed -i \
		-e 's:lightsquid.cfg:/etc/lightsquid/lightsquid.cfg:' \
		-e 's:common.pl:/usr/share/lightsquid/common.pl:' \
		*.cgi || die

	epatch "${FILESDIR}/${P}-path-fix.patch"

	epatch_user
}

src_install() {
	insinto /etc/lightsquid
	doins -r ip2name
	fowners -R lightsquid:squid /etc/lightsquid

	dodoc doc/*

	docinto examples
	dodoc *.cfg *.cfg.src

	dosbin lightparser.pl

	exeinto /var/www/lightsquid
	doexe *.cgi

	insinto /usr/share/lightsquid
	doins *.pl
	doins -r lang tpl

	insinto /usr/share/lightsquid/lang
	doins "${FILESDIR}/ru-utf8.lng"

	keepdir /var/lib/lightsquid
	fowners lightsquid:squid /var/lib/lightsquid

	systemd_dotmpfilesd "${FILESDIR}/${PN}.conf"
}
