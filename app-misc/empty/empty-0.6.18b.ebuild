# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils

DESCRIPTION="small shell-tool similar to expect(1)"
HOMEPAGE="http://empty.sourceforge.net"
SRC_URI="mirror://sourceforge/empty/${P}.tgz"
LICENSE="BSD"
SLOT="0"

KEYWORDS="~x86 ~amd64"
IUSE="examples"
DEPEND=""
RDEPEND="virtual/logger"

src_install() {
#	cd ${WORKDIR}/${P}
	dobin empty
	dodoc README
	doman empty.1
	if use examples; then
	  dodir usr/share/doc/${P}/examples/
	  insinto usr/share/doc/${P}/examples/
	  doins examples/*
	fi
}
