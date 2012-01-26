# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit eutils git-2 linux-mod cmake-utils

EGIT_REPO_URI="git://accel-ppp.git.sourceforge.net/gitroot/accel-ppp/accel-ppp"

DESCRIPTION="PPtP/L2TP/PPPoE Server for Linux"
SRC_URI=""
HOMEPAGE="http://accel-ppp.sourceforge.net/"

SLOT="0"
LICENSE="GPL"
KEYWORDS="~amd64 ~x86"
IUSE="pptp pppoe postgres debug shaper radius"

DEPEND=">=sys-libs/glibc-2.8
	dev-libs/openssl
	dev-libs/libaio
	postgres? ( dev-db/postgresql-base )"

RDEPEND="$DEPEND"

#BUILD_TARGETS="default"
#BUILD_PARAMS="KDIR=${KERNEL_DIR}"
CONFIG_CHECK="PPP"
if use pptp; then
	CONFIG_CHECK+="PPTP"
fi
if use pppoe; then
	CONFIG_CHECK+="PPPOE"
fi
MODULESD_PPTP_ALIASES=("net-pf-24 pptp")
PREFIX="/"
#MODULE_NAMES="pptp(extra:${S}/driver/)"

src_unpack () {
	git-2_src_unpack
}

src_prepare() {
	sed -i -e "/mkdir/d" "${S}/accel-pppd/CMakeLists.txt"
	sed -i -e "/echo/d" "${S}/accel-pppd/CMakeLists.txt"
	sed -i -e "/INSTALL/d" "${S}/driver/CMakeLists.txt"
}

src_configure() {
	if use debug; then
		mycmakeargs+=( "-DCMAKE_BUILD_TYPE=Debug" )
	fi

	if  use postgres; then
		mycmakeargs+=( "-DLOG_PGSQL=TRUE" )
	fi
	if use shaper; then
		mycmakeargs+=( "-DSHAPER=TRUE" )
	fi

	if ! use radius; then
		mycmakeargs+=( "-DRADIUS=FALSE" )
	fi

	mycmakeargs+=( "-DCMAKE_INSTALL_PREFIX=/usr" )

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	exeinto /etc/init.d
	newexe "${S}/contrib/gentoo/net-dialup/accel-ppp/files/accel-pppd-init" accel-pppd

	insinto /etc/conf.d
	newins "${S}/contrib/gentoo/net-dialup/accel-ppp/files/accel-pppd-confd" accel-pppd

	dodir /var/log/accel-ppp
	dodir /var/run/accel-ppp
	dodir /var/run/radattr
}
