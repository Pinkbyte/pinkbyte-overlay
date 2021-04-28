# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="C++ web services client library and utilities"
HOMEPAGE="http://wsdlpull.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# examples have confusing names, so - not adding USE for them
# also - do not use --disable-examples, as it is recognized as --enable-examples
IUSE="doc static-libs"

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	eapply "${FILESDIR}/${P}-buildsystem.patch"

	if ! use doc; then
		sed -i -e '/SUBDIRS/s/docs //' Makefile.am || die
	fi

	mv configure.in configure.ac || die
	rm -r config || die

	eapply_user
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
