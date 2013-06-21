# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# TODO: Check for work with new cairo
# with current stable - it segfaults
# Also this deps possibly not needed:
#	sci-libs/gsl

EAPI=5

inherit eutils

DESCRIPTION="Shows a movable and resizable spotlight on the screen"
HOMEPAGE="http://code.google.com/p/ardesia/"
SRC_URI="http://ardesia.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="sys-devel/gettext
	x11-libs/gtk+:3"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool"
RDEPEND="${COMMON_DEPEND}
	dev-libs/atk
	media-libs/fontconfig"

src_prepare() {
	# Upstream test is broken in case when
	# both GTK+-2 and GTK+-3 installed
	sed -i -e '/pkg_config_args=/s/gthread-2.0//' configure || die 'sed on configure failed'

	# Fix desktop file
	sed -i \
		-e '/Version/d' \
		-e '/Icon/s/.svg//' \
		-e '/Categories/s/$/;/' \
		desktop/spotlighter.desktop.in || die 'sed on desktop/spotlighter.desktop.in failed'

	epatch_user
}

src_configure() {
	# Disable compiling GTK+ test program
	econf --disable-gtktest
}

src_install() {
	# --docdir in configure does not work, so - use it here
	emake DESTDIR="${D}" spotlighterdocdir="${EPREFIX}/usr/share/doc/${PF}" install
	dodoc TODO
}
