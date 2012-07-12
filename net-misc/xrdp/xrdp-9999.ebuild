# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib cvs

DESCRIPTION="An open source remote desktop protocol(rdp) server."
HOMEPAGE="http://xrdp.sourceforge.net/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}
	|| ( x11-misc/x11vnc net-misc/vnc[server] net-misc/tightvnc )"

DESTDIR="/usr/$(get_libdir)/${PN}"

src_unpack() {
	ECVS_SERVER="xrdp.cvs.sourceforge.net:/cvsroot/xrdp"
	ECVS_USER="anonymous"
	ECVS_PASS=""
	ECVS_AUTH="pserver"
	ECVS_MODULE="xrdp"
	ECVS_LOCALNAME="xrdp"

	S="${WORKDIR}/${ECVS_LOCALNAME}"

	cvs_src_unpack
	cd "${S}"

	# fix makefile problem in sesrun
	epatch "${FILESDIR}/xrdp-9999-002-sesrun-config.patch"

	# fix sandbox security violation issues
        epatch "${FILESDIR}/xrdp-9999-001-sandbox-violation.patch"

	# domain as module name non-auto fix, and hidden modules patch
	epatch "${FILESDIR}/xrdp-9999-003-domain-as-module-name-noauto-fix-and-hidden-option.patch"

	# ignore client auth when module has preset
	# No longer required as it has been merged into CVS HEAD
	# xrdp/xrdp/xrdp_wm.c r1.63, Thu May 28 21:01:01 2009 UTC
	#epatch "${FILESDIR}/xrdp-9999-004-ignore-client-auth-on-preset.patch"

	autoreconf -fvi

	# fix cflags, broken paths, multilib, and insecure rpath in all makefiles
	for MAKE in $(find . -name Makefile) ; do
		sed -i "s:CFLAGS = -Wall -O. :CFLAGS += :
			s:/usr/xrdp:${DESTDIR}:g
			s:/usr/lib/:/usr/$(get_libdir)/:g
			s:rpath,\.:rpath,${DESTDIR}:g" ${MAKE}
	done

	#sed -i '/instfiles\/xrdp_control1.sh/ d' Makefile
}

src_configure() {
	econf --localstatedir=/var || die "econf failed"
}

src_compile() {
	emake -j1 DESTDIR="${DESTDIR}" || die "emake failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
	emake -j1 -C sesman/tools DESTDIR="${D}" install || die "emake install failed"
	emake -j1 -C sesman/libscp DESTDIR="${D}" install || die "emake install failed"
	dodoc design.txt readme.txt sesman/startwm.sh
	doman "${D}/usr/share/man/"*/*
	keepdir /var/log/${PN}
	rm -f "${D}/etc/xrdp/xrdp.sh" "${D}/etc/init.d/xrdp.sh"
	cp "${FILESDIR}/startwm.sh" "${D}/etc/xrdp/"
	cp -f "${FILESDIR}/xrdp.ini" "${D}/etc/xrdp/"
	chmod 755 "${D}/etc/xrdp/startwm.sh"
	newinitd "${FILESDIR}/${PN}-initd-cvs" ${PN}
	newconfd "${FILESDIR}/${PN}-confd-cvs" ${PN}
	sed -i "s:LIBDIR:$(get_libdir):" "${D}/etc/init.d/${PN}"
}

pkg_postinst() {
	# generate a new rsa key if needed
	if [ ! -e "/etc/xrdp/rsakeys.ini" ] ; then
		elog "Generating xrdp keys..."
		xrdp-keygen xrdp /etc/xrdp/rsakeys.ini
	fi
}
