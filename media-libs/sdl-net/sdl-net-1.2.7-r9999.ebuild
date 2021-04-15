# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# Pinkbyte: needed for eautoreconf, epatch
inherit autotools eutils

MY_P=${P/sdl-/SDL_}
DESCRIPTION="Simple Direct Media Layer Network Support Library"
HOMEPAGE="http://www.libsdl.org/projects/SDL_net/index.html"
SRC_URI="http://www.libsdl.org/projects/SDL_net/release/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="ipv6 static-libs"

DEPEND=">=media-libs/libsdl-1.2.5"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# Pinkbyte: patch for IPv6
	use ipv6 && epatch "${FILESDIR}/${P}-ipv6-new.patch"
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		$(use_enable ipv6)
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc CHANGES README
	if ! use static-libs ; then
		find "${D}" -type f -name '*.la' -exec rm {} + \
			|| die "la removal failed"
	fi
}
