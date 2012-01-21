# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.11"
AT_M4DIR=./config  # for aclocal called by eautoreconf
inherit eutils autotools linux-mod

DESCRIPTION="Native ZFS for Linux"
HOMEPAGE="http://zfsonlinux.org"
SRC_URI="http://github.com/downloads/zfsonlinux/${PN}/${P/_/-}.tar.gz"

LICENSE="CDDL GPL-2"
SLOT="0"
KEYWORDS="~amd64 -x86"
IUSE=""

DEPEND="
		>=sys-devel/spl-${PV}
		virtual/linux-sources
		"
RDEPEND="
		!sys-fs/zfs-fuse
		"

S="${WORKDIR}/${P/_/-}"

pkg_setup() {
	linux-mod_pkg_setup
	kernel_is gt 2 6 32 || die "Your kernel is too old. ${CATEGORY}/${PN} need 2.6.32 or newer."
	linux_config_exists || die "Your kernel sources are unconfigured."
	if linux_chkconfig_present PREEMPT; then
		eerror "${CATEGORY}/${PN} doesn't currently work with PREEMPT kernel."
		eerror "Please look at bug https://github.com/behlendorf/zfs/issues/83"
		die "PREEMPT kernel"
	fi
}

src_prepare() {
	epatch 	"${FILESDIR}/${PN}-0.6.0-includedir.patch"
	eautoreconf
}

src_configure() {
	set_arch_to_kernel
	econf \
		--with-config=all \
		--with-linux="${KV_OUT_DIR}" \
		--with-linux-obj="${KV_OUT_DIR}" \
		--with-spl=/usr/include/spl \
		--with-spl-obj=/usr/include/spl/module
}

src_compile() {
	set_arch_to_kernel
	default # _not_ the one from linux-mod
}

src_install() {
	emake DESTDIR="${D}" install || die 'emake install failed'
	newinitd "${FILESDIR}/zfs.initd" zfs
	keepdir /var/lock/zfs
	# Drop unwanted files
	rm -rf "${D}/usr/src" || die "removing unwanted files die"
}
