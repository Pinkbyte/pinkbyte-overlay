# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
EGIT_REPO_URI="git://github.com/itmages/itmages-service.git"
inherit distutils-r1 git-r3

DESCRIPTION="Scripts for uploading pictures to ITmages.ru"
HOMEPAGE="https://github.com/itmages/itmages-service"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]"

python_install_all() {
	distutils-r1_python_install_all
	# TODO: fix incorrect examples installation
	rm -r "${ED}/usr/share/doc/itmages/example" || die
}
