# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit autotools eutils flag-o-matic games

DESCRIPTION="An advanced NES, GB/GBC/GBA, TurboGrafx 16/CD, NGPC and Lynx emulator"
HOMEPAGE="http://mednafen.sourceforge.net/"
SRC_URI="http://forum.fobby.net/index.php?t=getfile&id=358 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa altivec cjk debug jack nls"

RDEPEND="virtual/opengl
	media-libs/libsndfile
	dev-libs/libcdio
	media-libs/libsdl[audio,joystick,video]
	media-libs/sdl-net
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}

pkg_setup() {
	append-flags -fno-strict-overflow
	append-flags -fomit-frame-pointer
	games_pkg_setup
}

src_prepare() {
	sed -i \
		-e 's:$(datadir)/locale:/usr/share/locale:' \
		-e 's:$(localedir):/usr/share/locale:' \
		$(find . -name 'Makefile.*') \
		|| die 'sed failed'
	sed -i \
		-e '/-fomit-frame-pointer/d' \
		-e '/-ffast-math/d' \
		-e '/^AX_CFLAGS_GCC_OPTION.*OPTIMIZER_FLAGS/d' \
		configure.ac \
		|| die "sed failed"
	eautoreconf
}

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		$(use_enable alsa) \
		$(use_enable altivec) \
		$(use_enable cjk cjk-fonts) \
		$(use_enable debug debugger) \
		$(use_enable jack) \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc Documentation/cheats.txt AUTHORS ChangeLog TODO
	dohtml Documentation/*
	prepgamesdirs
}
