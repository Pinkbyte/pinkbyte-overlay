# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Qt4 frontend for X Neural switcher"
HOMEPAGE="https://github.com/KsenZ/qxneur.git"
EGIT_REPO_URI="https://github.com/KsenZ/qxneur.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

src_install() {
	cd "${CMAKE_BUILD_DIR}"
	dobin "${PN}"
}
