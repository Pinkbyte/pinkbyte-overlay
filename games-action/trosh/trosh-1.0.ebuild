# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils gnome2-utils games

DESCRIPTION="The unshakeable mountain of a person with sunglasses on his quest to space and back"
HOMEPAGE="http://stabyourself.net/trosh/"
SRC_URI="http://stabyourself.net/dl.php?file=trosh/${PN}-source.zip -> ${P}.zip"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=games-engines/love-0.8.0"
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_install() {
	local dir=${GAMES_DATADIR}/love/${PN}

	exeinto "${dir}"
	doexe ${PN}.love

	games_make_wrapper ${PN} "love ${PN}.love" "${dir}"
	make_desktop_entry ${PN}

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	elog
	elog "${PN} savegames and configurations are stored in:"
	elog "~/.local/share/love/${PN}/"
	elog
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
