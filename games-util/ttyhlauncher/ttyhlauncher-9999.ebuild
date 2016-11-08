# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

EGIT_REPO_URI="https://github.com/dngulin/ttyhlauncher.git"
inherit eutils git-r3 qmake-utils

DESCRIPTION="ttyh.ru minecraft launcher"
HOMEPAGE="http://ttyh.ru"
SRC_URI=""

LICENSE="GPLv3"
SLOT="0"
KEYWORDS=""

DEPEND=">=dev-qt/qtcore-5.3.0:5
        >=dev-qt/qtgui-5.3.0:5
	>=dev-libs/quazip-0.7.2[qt5]"

RDEPEND="${DEPEND}"

src_configure() {
	eqmake5 "${PN}.pro"
}

src_install() {
	dobin "${PN}"
	newicon resources/favicon.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}"
}
