# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/emerald/emerald-0.8.4-r2.ebuild,v 1.4 2011/09/14 20:47:24 ssuominen Exp $

EAPI="4"

inherit eutils

THEMES_RELEASE=0.5.2

DESCRIPTION="Emerald Window Decorator"
HOMEPAGE="http://www.compiz.org/"
SRC_URI="http://releases.compiz.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

PDEPEND="~x11-themes/emerald-themes-${THEMES_RELEASE}"

RDEPEND="
	>=x11-libs/gtk+-2.8.0:2
	>=x11-libs/libwnck-2.14.2:1
	>=x11-wm/compiz-${PV}
"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	>=sys-devel/gettext-0.15
"

DOCS="AUTHORS ChangeLog INSTALL NEWS README TODO"

src_prepare() {
	# Fix pkg-config file pollution wrt #380197
	epatch "${FILESDIR}"/${P}-pkgconfig-pollution.patch
}

src_configure() {
	econf \
		--disable-static \
		--enable-fast-install \
		--disable-mime-update
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
