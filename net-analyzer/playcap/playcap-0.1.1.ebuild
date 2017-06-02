# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

MY_PN="PlayCap"
MY_P="${MY_PN}-${PV}"

inherit cmake-utils eutils

DESCRIPTION="Plays back captures made from wireshark, tcpdump, or any libpcap-based application"
HOMEPAGE="http://www.signal11.us/oss/playcap/"
SRC_URI="mirror://github/signal11/${MY_PN}/${MY_P}-Source.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-libs/libpcap
	x11-libs/fox:1.6[png]
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}-Source"

src_prepare() {
	sed -i -e 's/fox-config/fox-1.6-config/' CMakeLists.txt || die
	sed -i -e '/#include <stdio.h>/a#include <unistd.h>' PlaybackWindow.cpp || die
	cmake-utils_src_prepare
}

#src_install() {
#	cmake-utils_src_install
#	doicon famfamfam/*.png
#}
