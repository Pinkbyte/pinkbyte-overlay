# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools

DESCRIPTION="Locate and modify variables in executing processes (now with GameConqueror GUI)"
HOMEPAGE="http://code.google.com/p/scanmem/"
SRC_URI="http://scanmem.googlecode.com/files/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde gnome"

DEPEND="sys-libs/readline
	kde? ( kde-base/kdesu )
	gnome? ( x11-libs/gksu )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "/CFLAGS/d" Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
	--docdir=/usr/share/doc/${P} \
	$(use_enable kde gui)
	$(use_enable gnome gui)
}

src_install() {
	dobin scanmem
	doman scanmem.1
	dodoc NEWS ChangeLog
	use kde && sed -i 's/gksu -k --description "GameConqueror"/kdesu -c/' gui/gameconqueror
	use kde || use gnome && (cd "${S}/gui" && emake DESTDIR="${D}" install)
}
