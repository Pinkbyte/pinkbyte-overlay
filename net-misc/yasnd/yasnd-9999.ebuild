# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit git-2 autotools-utils

DESCRIPTION="Yet Another Stupid Network Daemon, tool that checks hosts' availability"
HOMEPAGE="http://github.com/Pinkbyte/yasnd"
EGIT_REPO_URI="http://github.com/Pinkbyte/yasnd.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
SRC_URI=""

RDEPEND="app-mobilephone/gammu
	dev-libs/confuse"

DEPEND="${RDEPEND}"

AUTOTOOLS_AUTORECONF="1"

src_install() {
	newinitd contrib/yasnd.openrc yasnd
	autotools-utils_src_install
}
