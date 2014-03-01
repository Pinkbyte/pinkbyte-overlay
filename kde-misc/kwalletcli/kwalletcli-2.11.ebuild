# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="CLI for the KDE Wallet"
HOMEPAGE="https://www.mirbsd.org/kwalletcli.htm"
SRC_URI="https://www.mirbsd.org/MirOS/dist/hosted/${PN}/${P}.tar.gz"

# TODO: add MirOS License?
LICENSE="LGPL-3+"
SLOT="4"
KEYWORDS=" ~amd64 ~x86"

RDEPEND="
	kde-base/kdelibs:4
	kde-base/kwalletd:4
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i \
		-e "s:-lQtCore:$($(tc-getPKG_CONFIG) --libs QtCore):" \
		GNUmakefile || die 'sed on GNUmakefile failed'
	sed -i -e 's:/usr/bin/env mksh:/bin/bash:' kwalletaskpass kwalletcli_getpin pinentry-kwallet || die 'failed to change shebang in scripts'
	epatch_user
}

src_compile() {
	tc-export CC CXX
	emake KDE_VER=4
}

src_install() {
	# Workaround for broken install script
	dodir /usr/bin /usr/share/man/man1

	emake DESTDIR="${D}" INSTALL_STRIP= install
}
