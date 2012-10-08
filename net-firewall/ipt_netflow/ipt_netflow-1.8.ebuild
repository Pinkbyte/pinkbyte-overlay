# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit linux-info linux-mod multilib toolchain-funcs

MY_PN="ipt-netflow"

DESCRIPTION="Netflow iptables module"
HOMEPAGE="http://sourceforge.net/projects/ipt-netflow"
SRC_URI="mirror://sourceforge/${MY_PN}/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="net-firewall/iptables"
DEPEND="${RDEPEND}
	virtual/linux-sources
	virtual/pkgconfig"

BUILD_TARGETS="all"
CONFIG_CHECK="IP_NF_IPTABLES"
MODULE_NAMES="ipt_NETFLOW(ipt_netflow:${S})"

IPT_LIB=/usr/$(get_libdir)/xtables

src_prepare() {
	sed -i -e 's:-I$(KDIR)/include::' \
		-e 's:gcc -O2:$(CC) $(CFLAGS) $(LDFLAGS):' \
		-e 's:gcc:$(CC) $(CFLAGS) $(LDFLAGS):' Makefile.in || die 'sed failed'
}

src_configure() {
	local IPT_VERSION="$($(tc-getPKG_CONFIG) --modversion xtables)"
	./configure --kver="${KV_FULL}" --kdir="${KV_DIR}" \
		--ipt-ver="${IPT_VERSION}" --ipt-lib="${IPT_LIB}" || die 'configure failed'
}

src_compile() {
	local ARCH=$(tc-arch-kernel)
	emake CC="$(tc-getCC)" all
}

src_install() {
	linux-mod_src_install
	exeinto "${IPT_LIB}"
	doexe libipt_NETFLOW.so
	insinto /usr/include
	doins ipt_NETFLOW.h
	dodoc README*
}
