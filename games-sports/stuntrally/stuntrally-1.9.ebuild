# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_P="StuntRally-${PV}-sources"

inherit cmake-utils eutils games

DESCRIPTION="Rally game focused on closed rally tracks with possible stunt elements (jumps, loops, pipes)."
HOMEPAGE="http://code.google.com/p/vdrift-ogre/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="dedicated +game editor"

S="${WORKDIR}/${MY_P}"

RDEPEND="game? (
		dev-games/ogre[cg,boost,ois,freeimage,opengl,zip]
		dev-games/mygui
		media-libs/libsdl:0
		media-libs/libvorbis
		media-libs/libogg
		x11-libs/libXcursor
	)
	dev-libs/boost
	net-libs/enet:1.3
	virtual/libstdc++"
DEPEND="${RDEPEND}"

REQUIRED_USE="editor? ( game )"

DOCS=( Readme.txt )
PATCHES=( "${FILESDIR}/${P}-sharedir-absolute-path.patch" )

src_configure() {
	local mycmakeargs=(
		-DSHARE_INSTALL="${GAMES_DATADIR}/${PN}"
		$(cmake-utils_use_build dedicated MASTER_SERVER)
		$(cmake-utils_use_build game GAME)
		$(cmake-utils_use_build editor EDITOR)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	use !editor && rm "${ED}/usr/share/applications/sr-editor.desktop" || die "remove of sr-editor.desktop failed"
	use !game  && rm "${ED}/usr/share/applications/${PN}.desktop" || die "remove of ${PN}.desktop failed"

	prepgamesdirs
}
