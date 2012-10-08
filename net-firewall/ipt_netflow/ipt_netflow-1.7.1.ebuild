# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit linux-info linux-mod multilib toolchain-funcs

MY_PN="ipt-netflow"

DESCRIPTION="Netflow iptables module"
HOMEPAGE="http://sourceforge.net/projects/ipt-netflow"
SRC_URI="mirror://sourceforge/${MY_PN}/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~ia64"
IUSE=""

RDEPEND="net-firewall/iptables"
DEPEND="${RDEPEND}
	 virtual/linux-sources"

BUILD_TARGETS="all"
CONFIG_CHECK="IP_NF_IPTABLES"
MODULE_NAMES="ipt_NETFLOW(ipt_netflow:${S})"

IPT_LIB=/usr/$(get_libdir)/xtables

src_prepare() {
	sed -i 's:-I$(KDIR)/include::' Makefile.in || die "sed 1 failed"
	sed -i 's:gcc -O2:$(CC) $(CFLAGS) $(LDFLAGS):' Makefile.in || die "sed 2 failed"
	sed -i 's:gcc:$(CC) $(CFLAGS) $(LDFLAGS):' Makefile.in || die "sed 3 failed"
}

src_configure() {
	./configure
}

src_compile() {
	local IPT_VERSION=`pkg-config --modversion xtables`
	local ARCH=$(tc-arch-kernel)
	emake CC="$(tc-getCC)" \
	KDIR="${KV_DIR}" KVERSION="${KV_FULL}" IPTABLES_VERSION="${IPT_VERSION}" \
	IPTABLES_MODULES="${IPT_LIB}" IPTSRC="" all || die "emake failed"
}

src_install() {
	linux-mod_src_install
	exeinto "${IPT_LIB}"
	doexe libipt_NETFLOW.so
	insinto /usr/include
	doins ipt_NETFLOW.h
	dodoc README
}
