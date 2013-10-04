# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils eutils

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
	epatch "${FILESDIR}/${P}-buildsystem.patch"

	sed -i -e '/^pkgincludedir=/s/xml/xmlpull/' src/xmlpull/Makefile.am || die
	sed -i -e '/^pkginclude_HEADERS/s/$(schema_h_sources)/$(schema_h_sources) $(wsdl_cc_sources)/' src/wsdlparser/Makefile.am || die

	if ! use doc; then
		sed -i -e '/SUBDIRS/s/docs //' Makefile.am || die
	fi

	rm -r config || die
	autotools-utils_src_prepare
}
