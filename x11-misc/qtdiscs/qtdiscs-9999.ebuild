# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://github.com/Pinkbyte/qtdiscs.git"
inherit eutils qt4-r2 git-2

DESCRIPTION="QtDiscs is a little program to show information about CD and DVD discs collection"
HOMEPAGE="http://github.com/Pinkbyte/qtdiscs"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
	x11-libs/qt-sql:4
"

DEPEND="${RDEPEND}"

DOCS=( README )
