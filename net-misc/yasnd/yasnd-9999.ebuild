# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

DESCRIPTION="Yet Another Stupid Network Daemon, tool that checks hosts' availability"
HOMEPAGE="http://github.com/Pinkbyte/yasnd"
EGIT_REPO_URI="http://github.com/Pinkbyte/yasnd.git"

inherit git-2 autotools

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
SRC_URI=""

RDEPEND="app-mobilephone/gammu
	dev-libs/confuse"

src_prepare() {
	eautoreconf
}
