# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/nfas/nfas-1.0_beta1.ebuild,v 1.1 2010/04/30 12:35:01 Pinkbyte Exp $

EAPI="2"

MY_PV="${PV/_beta/beta}"

DESCRIPTION="NFAS - NuFirewall Administration Suite"
HOMEPAGE="http://www.nufirewall.org/projects/nufirewall/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="dev-python/twisted"
DEPEND="${RDEPEND}"

SRC_URI="mirror://sourceforge/synce/nucentral-${MY_PV}.tar.bz2"

#S="${WORKDIR}/eas"

src_install() {
        sed -i 	-e 's/__import__(module_path)/__import__(name,{},{},"1")/' \
		site-packages/nucentral/core/module_loader.py || die "sed failed"

	insinto /usr
	doins -r usr/*
	keepdir /var/run/nucentral

	insinto /usr/lib/python2.6/site-packages
	doins -r site-packages/*

	insinto /etc
	doins -r etc/*

	insinto /var
	doins -r var/*
}
