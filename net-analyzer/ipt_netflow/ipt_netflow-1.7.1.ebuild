# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/kvm-kmod/kvm-kmod-88-r1.ebuild,v 1.1 2009/07/27 13:57:06 dang Exp $

EAPI="2"

inherit eutils linux-mod multilib

DESCRIPTION="Netflow iptables module"
HOMEPAGE="http://sourceforge.net/projects/ipt-netflow"

MY_PN=${PN/_/-}
SRC_URI="mirror://sourceforge/${MY_PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~ia64"
IUSE=""

RDEPEND="net-firewall/iptables"
DEPEND="${RDEPEND}
	 virtual/linux-sources"

#S=${WORKDIR}/${PN}

BUILD_TARGETS="all"
ARCH=$(tc-arch-kernel)
MODULE_NAMES="ipt_NETFLOW(ipt_netflow:${S})"

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK="IP_NF_IPTABLES"
	linux-mod_pkg_setup
}

src_prepare() {
	# OK, let's deal with this mess...
	sed -i 's:-I$(KDIR)/include::' Makefile.in || die "sed failed"
	sed -i 's:gcc -O2:$(CC) $(LDFLAGS) $(CFLAGS):' Makefile.in || die "sed failed!"
	sed -i 's:gcc:$(CC) $(LDFLAGS) $(CFLAGS):' Makefile.in || die "sed failed!"
	cp "${S}"/Makefile{.in,}
	epatch ${FILESDIR}/ipt_netflow-arguments-r1.patch
}

src_configure() {
	cd ${S}
	./configure
}

src_compile() {
	local IPT_VERSION=`pkg-config --modversion xtables`
	local IPT_LIB=/usr/$(get_libdir)/xtables
	MAKEOPTS="-j1"
	emake KDIR="${KV_DIR}" KVERSION="${KV_FULL}" IPTABLES_VERSION="${IPT_VERSION}" \
	IPTABLES_MODULES="${IPT_LIB}" IPTSRC="" all || die "emake failed"
}

src_install() {
	linux-mod_src_install
	exeinto /usr/$(get_libdir)/xtables
	doexe libipt_NETFLOW.so
	insinto /usr/include
	doins ipt_NETFLOW.h
	dodoc README
}
