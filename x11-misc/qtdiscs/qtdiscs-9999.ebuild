# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://gitlab.com/Pinkbyte/qtdiscs.git"
inherit qmake-utils git-r3

DESCRIPTION="QtDiscs is a little program to show information about CD and DVD discs collection"
HOMEPAGE="http://gitlab.com/Pinkbyte/qtdiscs"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
"

DEPEND="${RDEPEND}"

DOCS=( README )

src_configure() {
	eqmake5
}
