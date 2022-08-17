# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/dngulin/ttyhlauncher.git"
inherit cmake git-r3 xdg-utils

DESCRIPTION="ttyh.ru minecraft launcher"
HOMEPAGE="https://ttyh.ru"
SRC_URI=""

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""

BDEPEND="dev-qt/linguist-tools:5"
RDEPEND=">=dev-qt/qtcore-5.7.0:5
        >=dev-qt/qtgui-5.7.0:5[png]
	>=dev-qt/qtwidgets-5.7.0:5
	>=dev-qt/qtnetwork-5.7.0:5
	>=dev-qt/qtconcurrent-5.7.0:5
	dev-libs/libzip:0="
DEPEND="${RDEPEND}"

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
