# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://gitlab.com/Pinkbyte/yasnd.git"
inherit autotools git-r3

DESCRIPTION="Yet Another Stupid Network Daemon, tool that checks hosts' availability"
HOMEPAGE="https://gitlab.com/Pinkbyte/yasnd"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="app-mobilephone/gammu
	dev-libs/confuse:="
DEPEND="${RDEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}

src_install() {
	newinitd contrib/yasnd.openrc yasnd
	newinitd contrib/yasnd-early.openrc yasnd-early
	default
}
