# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools multilib

REL_TAG="0.8~beta2"

MY_PV=${PV/_beta2_p/~beta2-1+svn}
MY_P="${PN}_${MY_PV}"

MY_CONF_PV=${PV/_beta2_p/~beta2-1+svn}-conf
MY_CONF_P="${PN}-conf_${MY_PV}"

DESCRIPTION="Frontend for iptables featuring easy to use command line utils, rule- and logdaemons"
HOMEPAGE="http://www.vuurmuur.org"
SRC_URI="ftp://ftp.vuurmuur.org/ubuntu/dists/jaunty/svn/${MY_P}.tar.gz
	ftp://ftp.vuurmuur.org/ubuntu/dists/jaunty/svn/${MY_CONF_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="logrotate"

DEPEND="=net-libs/libvuurmuur-${PV}
	>=sys-libs/ncurses-5"
RDEPEND="${DEPEND}
	logrotate? ( app-admin/logrotate )"

S="${WORKDIR}/${PN}-${REL_TAG}"

src_prepare() {
	eautoreconf
	cd "${WORKDIR}/${PN}-conf-${REL_TAG}"
	eautoreconf
	sed -i 's/nb//' po/LINGUAS
}

src_configure() {
	econf \
		--with-libvuurmuur-includes=/usr/include \
		--with-libvuurmuur-libraries=/usr/$(get_libdir)
	cd "${WORKDIR}/${PN}-conf-${REL_TAG}"
	econf \
		--with-libvuurmuur-includes=/usr/include \
		--with-libvuurmuur-libraries=/usr/$(get_libdir) \
		--with-localedir=/usr/share/locale \
		--with-widec=yes
}

src_compile() {
	emake -C "../${PN}-conf-${REL_TAG}"
}

src_install() {
	emake DESTDIR="${D}" install

	newinitd "${FILESDIR}"/vuurmuur.init vuurmuur
	newconfd "${FILESDIR}"/vuurmuur.conf vuurmuur

	if use logrotate; then
		insinto /etc/logrotate.d
		newins scripts/vuurmuur-logrotate vuurmuur
	fi

	insopts -m0600
	insinto /etc/vuurmuur
	newins config/config.conf.sample config.conf

	cd "../${PN}-conf-${REL_TAG}"

	emake DESTDIR="${D}" install
}

pkg_postinst() {
	elog "Please read the manual on www.vuurmuur.org now - you have"
	elog "been warned!"
	elog
	elog "If this is a new install, make sure you define some rules"
	elog "BEFORE you start the daemon in order not to lock yourself"
	elog "out. The necessary steps are:"
	elog "1) vuurmuur_conf"
	elog "2) /etc/init.d/vuurmuur start"
	elog "3) rc-update add vuurmuur default"
}
