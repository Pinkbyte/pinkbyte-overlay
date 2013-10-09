# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="C/C++ routines for fast encoding/decoding data into and from a base64-encoded format"
HOMEPAGE="http://libb64.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"
RDEPEND=""

src_prepare() {
	# Respect compiler environment
	tc-export CC CXX

	# Build shared library instead of static
	epatch "${FILESDIR}/${P}-build-shared-lib.patch"

	epatch_user
}

src_compile() {
	# Build library only
	emake all_src
}

src_install() {
	doheader -r include/b64
	dolib.so "src/${PN}.so"
	dosym "${PN}.so" "/usr/$(get_libdir)/${PN}.so.1"
}
