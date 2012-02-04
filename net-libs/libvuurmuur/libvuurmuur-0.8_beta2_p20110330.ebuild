# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit autotools multilib

MY_PV=${PV/_beta2_p/~beta2-1+svn}
MY_P="${PN}_${MY_PV}"

DESCRIPTION="Libraries and plugins required by Vuurmuur"
HOMEPAGE="http://www.vuurmuur.org"
SRC_URI="ftp://ftp.vuurmuur.org/ubuntu/dists/jaunty/svn/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-firewall/iptables"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-0.8~beta2"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf --with-plugindir=/usr/$(get_libdir)
}

src_install() {
	emake DESTDIR="${D}" install || die "installing libvuurmuur failed"

	# files needed but not yet installed by make
	dodir /etc/vuurmuur/textdir || die "installing textdir failed"
	insinto /etc/vuurmuur/plugins
	doins plugins/textdir/textdir.conf || die "installing textdir.conf failed"
}
