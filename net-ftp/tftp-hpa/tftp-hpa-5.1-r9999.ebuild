# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit eutils

DESCRIPTION="port of the OpenBSD TFTP server"
HOMEPAGE="http://www.kernel.org/pub/software/network/tftp/"
SRC_URI="mirror://kernel/software/network/tftp/${PN}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="ipv6 readline selinux tcpd"

RDEPEND="selinux? ( sec-policy/selinux-tftpd )
	readline? ( sys-libs/readline )
	tcpd? ( sys-apps/tcp-wrappers )
	!net-ftp/atftp
	!net-ftp/netkit-tftp"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	readline? ( sys-libs/readline )
	tcpd? ( sys-apps/tcp-wrappers )"

src_configure() {
	# Pinkbyte: additional patch for Windows clients
	epatch "${FILESDIR}"/${P}-filecase.patch
	#
	econf \
		$(use_with ipv6) \
		$(use_with tcpd tcpwrappers) \
		$(use_with readline)
}

src_install() {
	emake INSTALLROOT="${D}" install
	dodoc README* CHANGES tftpd/sample.rules

	# iputils installs this
	rm "${D}"/usr/share/man/man8/tftpd.8 || die

	newconfd "${FILESDIR}"/in.tftpd.confd-0.44 in.tftpd
	newinitd "${FILESDIR}"/in.tftpd.rc6 in.tftpd
	insinto /etc/xinetd.d
	newins "${FILESDIR}"/tftp.xinetd tftp
}
