# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit git-2 autotools-utils

DESCRIPTION="A console-based network monitoring utility"
HOMEPAGE="http://fedorahosted.org/iptraf-ng/"
SRC_URI=""
EGIT_REPO_URI="git://git.fedorahosted.org/git/iptraf-ng.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=sys-libs/ncurses-5.7-r7"
DEPEND="${RDEPEND}
	!net-analyzer/iptraf"

AUTOTOOLS_AUTORECONF="1"

src_prepare() {
	./gen-version
	autotools-utils_src_prepare
}

src_install() {
	autotools-utils_src_install
	dohtml -r Documentation
	keepdir /var/{lib,log,lock}/iptraf-ng #376157
}
