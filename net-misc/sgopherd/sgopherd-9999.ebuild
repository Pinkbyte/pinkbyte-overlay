# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://www.uninformativ.de/git/sgopherd.git"

inherit git-r3

DESCRIPTION="Small Gopher Server written in GNU Bash"
HOMEPAGE="https://www.uninformativ.de/git/sgopherd/file/README.html"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

DEPEND=""
RDEPEND="app-shells/bash
	sys-apps/sed
	sys-apps/xinetd"

src_prepare() {
	# Set default user to run sgopherd
	sed -i -e '/user/s/http/nobody/' xinetd/xinetd-example.conf || die 'sed failed'
	default
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
