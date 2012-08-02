# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://github.com/AlexCones/LORA.git"

inherit eutils git-2

DESCRIPTION="LORA is console client for linux.org.ru forum"
HOMEPAGE="https://github.com/AlexCones/LORA"
LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="sys-apps/sed
	dev-python/lxml
	app-shells/bash
	"

src_compile() { :; }

src_install() {
	dodoc README
	rm -rf {.git,COPYING,LICENSE,README}
	insinto /opt/lora
	doins -r .
	fperms +x /opt/lora/lora.sh
}

pkg_postinst() {
	einfo "LORA installed into /opt/lora"
	einfo "Feel free to change PATH variable or run it manually like '/opt/lora/lora.sh'"
}
