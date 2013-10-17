# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/dynamips/dynamips-0.2.8-r1.ebuild,v 1.1 2013/08/25 14:51:00 pinkbyte Exp $

EAPI=5

MY_P="${P}-source"

inherit eutils toolchain-funcs

DESCRIPTION="Cisco 7200/3600 Simulator"
HOMEPAGE="http://www.gns3.net/dynamips/"
SRC_URI="mirror://sourceforge/project/gns-3/Dynamips/${PV}/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip
	dev-libs/elfutils
	net-libs/libpcap"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"

	# enable verbose build
	# do not link to libelf statically
	sed -i \
		-e 's/@$(CC)/$(CC)/g' \
		-e 's:/usr/$(DYNAMIPS_LIB)/libelf.a:-lelf:' \
		stable/Makefile || die 'sed on Makefile failed'
	sed -i -e
	# respect compiler
	tc-export CC

	epatch_user
}

src_compile() {
	if use amd64 || use x86; then
		emake DYNAMIPS_ARCH="${ARCH}"
	else
		emake DYNAMIS_ARCH="nojit"
	fi
}

src_install () {
	newbin dynamips.stable dynamips
	dobin stable/nvram_export
	doman man/*
	dodoc TODO README README.hypervisor
}
