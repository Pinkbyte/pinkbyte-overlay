# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils qt4-r2 vcs-snapshot

DESCRIPTION="QtDiscs is a little program to show information about CD and DVD discs collection"
HOMEPAGE="http://github.com/Pinkbyte/qtdiscs"
SRC_URI="https://github.com/Pinkbyte/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
	x11-libs/qt-sql:4
"

DEPEND="${RDEPEND}"

DOCS=( README )
