# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2"

inherit git-2 distutils

DESCRIPTION="Scripts for uploading pictures to ITmages.ru"
HOMEPAGE="https://github.com/itmages/itmages-service"
EGIT_REPO_URI="git://github.com/itmages/itmages-service.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-python/pycurl
	dev-python/dbus-python
	dev-python/lxml
	dev-python/pygobject"
