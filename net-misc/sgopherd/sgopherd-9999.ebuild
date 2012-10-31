# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://github.com/vain/sgopherd.git"

inherit git-2

DESCRIPTION="Small Gopher Server written in GNU Bash"
HOMEPAGE="https://github.com/vain/sgopherd"
SRC_URI=""

LICENSE="PIZZA-WARE"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash
	sys-apps/sed
	sys-apps/xinetd"

src_prepare() {
	# Set default user to run sgopherd
	sed -i -e '/user/s/http/nobody/' xinetd/xinetd-example.conf || die 'sed failed'
}

src_install() {
	dodoc README
	doman man8/"${PN}".8
	dobin "${PN}"
	insinto /etc/xinetd.d
	newins xinetd/xinetd-example.conf "${PN}"
	# TODO: add installation of systemd-related files
}

pkg_postinst() {
	elog "${PN} can be launched through xinetd"
	elog "Configuration options are in /etc/xinetd.d/${PN}"
}
