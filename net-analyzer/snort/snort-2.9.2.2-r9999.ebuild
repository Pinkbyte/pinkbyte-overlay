# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/snort/snort-2.9.2.2.ebuild,v 1.1 2012/04/04 09:39:53 patrick Exp $

EAPI="2"
inherit eutils autotools flag-o-matic multilib

DESCRIPTION="The de facto standard for intrusion detection/prevention"
HOMEPAGE="http://www.snort.org/"
SRC_URI="http://www.snort.org/dl/snort-current/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~mips"
IUSE="static +dynamicplugin +zlib +gre +mpls +targetbased +decoder-preprocessor-rules
+ppm +perfprofiling linux-smp-stats inline-init-failopen +threads debug +active-response
+normalizer reload-error-restart +react +flexresp3 +paf large-pcap-64bit
aruba mysql odbc postgres selinux
snortsam"

DEPEND=">=net-libs/libpcap-1.0.0
	>=net-libs/daq-0.6
	>=dev-libs/libpcre-6.0
	dev-libs/libdnet
	postgres? ( dev-db/postgresql-base )
	mysql? ( virtual/mysql )
	odbc? ( dev-db/unixODBC )
	zlib? ( sys-libs/zlib )"

RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-snort )"

pkg_setup() {

	if use zlib && ! use dynamicplugin; then
		eerror "You have enabled the 'zlib' USE flag but not the 'dynamicplugin' USE flag."
		eerror "'zlib' requires 'dynamicplugin' be enabled."
		die
	fi

	# pre_inst() is a better place to put this
	# but we need it here for the 'fowners' statements in src_install()
	enewgroup snort
	enewuser snort -1 -1 /dev/null snort

}

src_prepare() {

	#Multilib fix for the sf_engine
	einfo "Applying multilib fix."
	sed -i -e 's|${exec_prefix}/lib|${exec_prefix}/'$(get_libdir)'|g' \
		"${WORKDIR}/${P}/src/dynamic-plugins/sf_engine/Makefile.am" \
		|| die "sed for sf_engine failed"

	#Multilib fix for the curent set of dynamic-preprocessors
	for i in ftptelnet smtp ssh dns ssl dcerpc2 sdf imap pop rzb_saac sip reputation gtp modbus dnp3; do
		sed -i -e 's|${exec_prefix}/lib|${exec_prefix}/'$(get_libdir)'|g' \
			"${WORKDIR}/${P}/src/dynamic-preprocessors/$i/Makefile.am" \
			|| die "sed for $i failed."
	done

	# Pinkbyte: add patch for snortsam support
	if use snortsam; then
		epatch "${FILESDIR}/snortsam-${PV}.diff.gz"
		epatch "${FILESDIR}/snortsam-redirect-${PV}.patch"
		use debug && append-flags "-DFWSAMDEBUG"
	fi
	#

	AT_M4DIR=m4 eautoreconf
}

src_configure() {
	econf \
		$(use_enable !static shared) \
		$(use_enable static) \
		$(use_enable static so-with-static-lib) \
		$(use_enable dynamicplugin) \
		$(use_enable zlib) \
		$(use_enable gre) \
		$(use_enable mpls) \
		$(use_enable targetbased) \
		$(use_enable decoder-preprocessor-rules) \
		$(use_enable ppm) \
		$(use_enable perfprofiling) \
		$(use_enable linux-smp-stats) \
		$(use_enable inline-init-failopen) \
		$(use_enable threads pthread) \
		$(use_enable debug) \
		$(use_enable debug debug-msgs) \
		$(use_enable debug corefiles) \
		$(use_enable !debug dlclose) \
		$(use_enable active-response) \
		$(use_enable normalizer) \
		$(use_enable reload-error-restart) \
		$(use_enable react) \
		$(use_enable flexresp3) \
		$(use_enable paf) \
		$(use_enable large-pcap-64bit large-pcap) \
		$(use_enable aruba) \
		$(use_with mysql) \
		$(use_with odbc) \
		$(use_with postgres postgresql) \
		--enable-ipv6 \
		--enable-reload \
		--disable-prelude \
		--disable-build-dynamic-examples \
		--disable-profile \
		--disable-ppm-test \
		--disable-intel-soft-cpm \
		--disable-static-daq \
		--disable-rzb-saac \
		--without-oracle
}

src_install() {

	emake DESTDIR="${D}" install || die "emake failed"

	dodir /var/log/snort \
		/var/run/snort \
		/etc/snort/rules \
		/etc/snort/so_rules \
		/usr/$(get_libdir)/snort_dynamicrules \
			|| die "Failed to create core directories"

	# config.log and build.log are needed by Sourcefire
	# to trouble shoot build problems and bug reports so we are
	# perserving them incase the user needs upstream support.
	dodoc RELEASE.NOTES ChangeLog \
		doc/* \
		tools/u2boat/README.u2boat \
		schemas/* || die "Failed to install snort docs"

	insinto /etc/snort
	doins etc/attribute_table.dtd \
		etc/classification.config \
		etc/gen-msg.map \
		etc/reference.config \
		etc/threshold.conf \
		etc/unicode.map || die "Failed to install docs in etc"

	# We use snort.conf.distrib because the config file is complicated
	# and the one shipped with snort can change drastically between versions.
	# Users should migrate setting by hand and not with etc-update.
	newins etc/snort.conf snort.conf.distrib \
		|| die "Failed to add snort.conf.distrib"

	# config.log and build.log are needed by Sourcefire
	# to troubleshoot build problems and bug reports so we are
	# perserving them incase the user needs upstream support.
	# 'die' was intentionally not added here.
	if [ -f "${WORKDIR}/${PF}/config.log" ]; then
		dodoc "${WORKDIR}/${PF}/config.log"
	fi
	if [ -f "${T}/build.log" ]; then
		dodoc "${T}/build.log"
	fi

	insinto /etc/snort/preproc_rules
	doins preproc_rules/decoder.rules \
		preproc_rules/preprocessor.rules \
		preproc_rules/sensitive-data.rules || die "Failed to install preproc rule files"

	fowners -R snort:snort \
		/var/log/snort \
		/var/run/snort \
		/etc/snort || die

	newinitd "${FILESDIR}/snort.rc11" snort || die "Failed to install snort init script"
	newconfd "${FILESDIR}/snort.confd.2" snort || die "Failed to install snort confd file"

	# Sourcefire uses Makefiles to install docs causing Bug #297190.
	# This removes the unwanted doc directory and rogue Makefiles.
	rm -rf "${D}"usr/share/doc/snort || die "Failed to remove SF doc directories"
	rm "${D}"usr/share/doc/"${PF}"/Makefile* || die "Failed to remove doc make files"

	#Remove unneeded .la files (Bug #382863)
	rm "${D}"usr/$(get_libdir)/snort_dynamicengine/libsf_engine.la || die
	rm "${D}"usr/$(get_libdir)/snort_dynamicpreprocessor/libsf_*_preproc.la || die "Failed to remove libsf_?_preproc.la"

	# Set the correct lib path for dynamicengine, dynamicpreprocessor, and dynamicdetection
	sed -i -e 's|/usr/local/lib|/usr/'$(get_libdir)'|g' \
		"${D}etc/snort/snort.conf.distrib" || die

	# Set the correct rule location in the config
	sed -i -e 's|RULE_PATH ../rules|RULE_PATH /etc/snort/rules|g' \
		"${D}etc/snort/snort.conf.distrib" || die

	# Set the correct preprocessor/decoder rule location in the config
	sed -i -e 's|PREPROC_RULE_PATH ../preproc_rules|PREPROC_RULE_PATH /etc/snort/preproc_rules|g' \
		"${D}etc/snort/snort.conf.distrib" || die

	# Enable the preprocessor/decoder rules
	sed -i -e 's|^# include $PREPROC_RULE_PATH|include $PREPROC_RULE_PATH|g' \
		"${D}etc/snort/snort.conf.distrib" || die

	sed -i -e 's|^# dynamicdetection directory|dynamicdetection directory|g' \
		"${D}etc/snort/snort.conf.distrib" || die

	# Just some clean up of trailing /'s in the config
	sed -i -e 's|snort_dynamicpreprocessor/$|snort_dynamicpreprocessor|g' \
		"${D}etc/snort/snort.conf.distrib" || die

	# Make it clear in the config where these are...
	sed -i -e 's|^include classification.config|include /etc/snort/classification.config|g' \
		"${D}etc/snort/snort.conf.distrib" || die

	sed -i -e 's|^include reference.config|include /etc/snort/reference.config|g' \
		"${D}etc/snort/snort.conf.distrib" || die

	# Disable all rule files by default.
	sed -i -e 's|^include $RULE_PATH|# include $RULE_PATH|g' \
		"${D}etc/snort/snort.conf.distrib" || die

	# Disable normalizer preprocessor config if normalizer USE flag not set.
	if ! use normalizer; then
		sed -i -e 's|^preprocessor normalize|#preprocessor normalize|g' \
			"${D}etc/snort/snort.conf.distrib" || die
	fi

	# Set the configured DAQ to afpacket
	sed -i -e 's|^# config daq: <type>|config daq: afpacket|g' \
		"${D}etc/snort/snort.conf.distrib" || die

	# Set the location of the DAQ modules
	sed -i -e 's|^# config daq_dir: <dir>|config daq_dir: /usr/'$(get_libdir)'/daq|g' \
		"${D}etc/snort/snort.conf.distrib" || die

	# Set the DAQ mode to passive
	sed -i -e 's|^# config daq_mode: <mode>|config daq_mode: passive|g' \
		"${D}etc/snort/snort.conf.distrib" || die

	# Set snort to run as snort:snort
	sed -i -e 's|^# config set_gid:|config set_gid: snort|g' \
		"${D}etc/snort/snort.conf.distrib" || die
	sed -i -e 's|^# config set_uid:|config set_uid: snort|g' \
		"${D}etc/snort/snort.conf.distrib" || die

	# Set the default log dir
	sed -i -e 's|^# config logdir:|config logdir: /var/log/snort/|g' \
		"${D}etc/snort/snort.conf.distrib" || die

	# Set the correct so_rule location in the config
	 sed -i -e 's|SO_RULE_PATH ../so_rules|SO_RULE_PATH /etc/snort/so_rules|g' \
		 "${D}etc/snort/snort.conf.distrib" || die
}

pkg_postinst() {

	einfo "There have been a number of improvements and new features"
	einfo "added to ${P}. Please review the RELEASE.NOTES and"
	einfo "ChangLog located in /usr/share/doc/${PF}."
	einfo
	elog "The Sourcefire Vulnerability Research Team (VRT) recommends that"
	elog "users migrate their snort.conf customizations to the latest config"
	elog "file released by the VRT. You can find the latest version of the"
	elog "Snort config file in /etc/snort/snort.conf.distrib."
	elog
	elog "!! It is important that you migrate to this new snort.conf file !!"
	elog
	elog "This version of the ebuild includes an updated init.d file and"
	elog "conf.d file that rely on options found in the latest Snort"
	elog "config file provided by the VRT."

	if use debug; then
		elog "You have the 'debug' USE flag enabled. If this has been done to"
		elog "troubleshoot an issue by producing a core dump or a back trace,"
		elog "then you need to also ensure the FEATURES variable in make.conf"
		elog "contains the 'nostrip' option."
	fi
}
