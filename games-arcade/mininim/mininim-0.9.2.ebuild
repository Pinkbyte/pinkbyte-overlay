# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="The Advanced Prince of Persia Engine"
HOMEPAGE="https://github.com/oitofelix/mininim"
SRC_URI="https://github.com/oitofelix/mininim/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/allegro:5[alsa,gtk,png,truetype,vorbis]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-sandbox.patch" )

src_prepare() {
	eapply ${PATCHES[@]}
	eapply_user
	eautoreconf
}

src_compile() {
	unset LINGUAS
	default_src_compile
}
