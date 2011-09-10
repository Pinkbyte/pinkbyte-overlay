# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit kde4-base

SVN_VER="2.0~svn906377"

DESCRIPTION="http://plasma-widget-kbstate.sourcearchive.com/"
HOMEPAGE="http://www.kde-look.org/content/show.php/cpuload?content=79476"
SRC_URI="http://plasma-widget-kbstate.sourcearchive.com/downloads/${SVN_VER}/${PN}_${SVN_VER}.orig.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="
	$(add_kdebase_dep plasma-workspace)
"

S="${WORKDIR}/plasmoid-kbstate-${SVN_VER}"

CMAKE_IN_SOURCE_BUILD=1

src_prepare() {
	epatch "${FILESDIR}/cmake-fix.patch"
	kde4-base_src_prepare
}
