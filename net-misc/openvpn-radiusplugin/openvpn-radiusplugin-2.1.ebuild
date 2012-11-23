# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MY_PN="radiusplugin"
MY_P="${MY_PN}_v${PV}"

inherit flag-o-matic multilib toolchain-funcs

DESCRIPTION="Radiusplugin for OpenVPN"
HOMEPAGE="http://www.nongnu.org/radiusplugin/index.html"
SRC_URI="http://www.nongnu.org/radiusplugin/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# TODO: handle with optional doxygen documentation generation
#IUSE="doc"
IUSE=""

DEPEND="dev-libs/libgcrypt"
RDEPEND="${DEPEND}
	net-misc/openvpn"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	# Make compilation process verbose
	# Respect CFLAGS, LDFLAGS and compiler
	sed -i \
		-e 's:@$(CC):$(CC):g' \
		-e '/^CFLAGS/d' \
		-e '/^LDFLAGS/d' \
		Makefile || die 'sed on Makefile failed'
	# needed for proper compilation
	append-cflags -shared -fPIC -DPIC
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	insinto /etc/openvpn
	doins "${MY_PN}.cnf"
	exeinto "/usr/$(get_libdir)/openvpn"
	doexe "${MY_PN}.so"
	dodoc README ToDo
}

pkg_postinst() {
	elog "Radiusplugin is installed into '/usr/$(get_libdir)/openvpn'"
	elog "Path for it should be set in your openvpn.conf"
}
