# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

MY_SERVER_P="scrcpy-server-v${PV}"

DESCRIPTION="Display and control your Android device"
HOMEPAGE="https://blog.rom1v.com/2018/03/introducing-scrcpy/"
SRC_URI="
	https://github.com/Genymobile/scrcpy/archive/v${PV}.tar.gz
	https://github.com/Genymobile/scrcpy/releases/download/v${PV}/${MY_SERVER_P}
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND="
	media-libs/libsdl2
	media-video/ffmpeg:0=
"
DEPEND="${RDEPEND}"

src_configure() {
	local emesonargs=(
		-Db_lto=true
		-Dprebuilt_server="${DISTDIR}/${MY_SERVER_P}"
	)
	meson_src_configure
}
