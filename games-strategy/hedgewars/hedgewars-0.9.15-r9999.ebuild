# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/hedgewars/hedgewars-0.9.14.1.ebuild,v 1.1 2010/11/15 19:56:46 mr_bones_ Exp $

# Pinkbyte: ebuild from bugs.gentoo.org/247114 with full server support

EAPI=2
inherit cmake-utils eutils games

MY_P=${PN}-src-${PV}
DESCRIPTION="Free Worms-like turn based strategy game"
HOMEPAGE="http://hedgewars.org/"
SRC_URI="http://hedgewars.org/download/${MY_P}.tar.bz2"

LICENSE="GPL-2 Apache-2.0 FDL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="server"

RDEPEND="x11-libs/qt-gui:4
	media-libs/libsdl[audio,opengl,video]
	media-libs/sdl-ttf
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-image[png]
	media-libs/sdl-net
	dev-lang/lua"
DEPEND="${RDEPEND}
	>=dev-lang/fpc-2.4
	server? ( >=dev-lang/ghc-6.10.4-r1
		dev-haskell/stm
		dev-haskell/network
		dev-haskell/time
		dev-haskell/dataenc
		dev-haskell/hslogger
		dev-haskell/utf8-string
	)"
RDEPEND="${RDEPEND}
	>=media-fonts/dejavu-2.28"

S=${WORKDIR}/${MY_P}

src_configure() {
	mycmakeargs="-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX} -DDATA_INSTALL_DIR=${GAMES_DATADIR} -DCMAKE_VERBOSE_MAKEFILE=TRUE $(cmake-utils_use_with server SERVER)"
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	DOCS="ChangeLog.txt README" cmake-utils_src_install
	rm -f "${D}"/usr/share/games/hedgewars/Data/Fonts/DejaVuSans-Bold.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSans-Bold.ttf \
		"${GAMES_DATADIR}"/hedgewars/Data/Fonts/DejaVuSans-Bold.ttf
	newicon QTfrontend/res/hh25x25.png ${PN}.png
	make_desktop_entry ${PN} Hedgewars
	doman man/${PN}.6
	prepgamesdirs
}
