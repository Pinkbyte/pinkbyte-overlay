# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://github.com/pbek/QOwnNotes.git"
inherit eutils git-r3 qmake-utils

DESCRIPTION="Open source notepad with Owncloud support"
HOMEPAGE="http://www.qownnotes.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}"

DOCS=( CHANGELOG.md README.md SHORTCUTS.md )

src_configure() {
	eqmake5 src/QOwnNotes.pro
}

src_install() {
	dobin QOwnNotes
	einstalldocs
}
