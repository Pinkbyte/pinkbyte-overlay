# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit cmake-utils git-2

DESCRIPTION="Qt4 frontend for X Neural switcher"
HOMEPAGE="https://gitorious.org/qxneur/qxneur"
EGIT_PROJECT="qxneur"
EGIT_REPO_URI="git://gitorious.org/qxneur/qxneur.git"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

src_install() {
	cd "${CMAKE_BUILD_DIR}"
	dobin "${PN}"
}
