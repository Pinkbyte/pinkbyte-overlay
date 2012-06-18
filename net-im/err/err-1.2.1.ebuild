# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DISTUTILS_SRC_TEST="setup.py"

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2:2.7"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils user

DESCRIPTION="err is a plugin based XMPP chatbot designed to be easily deployable, extensible and maintainable."
HOMEPAGE="http://gbin.github.com/err/"

SRC_URI="mirror://pypi/e/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND="dev-python/xmpppy
	dev-python/python-daemon
	dev-python/yapsy"

pkg_setup() {
	python_pkg_setup
	ebegin "Creating err group and user"
	enewgroup 'err'
	enewuser 'err' -1 -1 -1 'err'
	eend ${?}
}

src_install() {
	distutils_src_install
	newinitd "${FILESDIR}"/errd.initd errd
	newconfd "${FILESDIR}"/errd.confd errd
	dodir /etc/${PN}
	dodir /var/lib/${PN}
	keepdir /var/log/${PN}
	keepdir /var/run/${PN}
	fowners -R err:err /var/lib/${PN}
	fowners -R err:err /var/log/${PN}
	fowners -R err:err /var/run/${PN}
	insinto /etc/${PN}
	newins errbot/config-template.py config.py
}
