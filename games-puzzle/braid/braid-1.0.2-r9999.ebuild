# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games versionator

MY_PV="$(get_version_component_range 3)"

DESCRIPTION="Platform game where you manipulate flow of time"
HOMEPAGE="http://braid-game.com"
SRC_URI="${PN}-linux-build${MY_PV}.run.bin
	linguas_ru? ( ${PN}-rus.tar.bz2 )"

LICENSE="Arphic MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="linguas_ru"
RESTRICT="fetch mirror strip"

DEPEND="app-arch/unzip"
RDEPEND="media-libs/libsdl[audio,joystick,video]
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdmcp
	x11-libs/libXext
	virtual/opengl
	media-gfx/nvidia-cg-toolkit"

S="${WORKDIR}/data"

pkg_nofetch() {
	elog
	elog "Download ${SRC_URI} from ${HOMEPAGE} and place it in ${DISTDIR}"
	elog
}

src_unpack() {
	# self unpacking zip archive; unzip warns about the exe stuff
	local a="${DISTDIR}/${PN}-linux-build${MY_PV}.run.bin"
	echo ">>> Unpacking ${a} to ${PWD}"
	unzip -q "${a}"
	[ $? -gt 1 ] && die "unpacking failed"

	if use linguas_ru; then
		unpack "${PN}-rus.tar.bz2"
		mv "${S}/package0.zip" "${S}/gamedata/data" || die
		mv "${S}/strings/english.mo" "${S}/gamedata/data/strings" || die
	fi
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	exeinto "${dir}"

	doins -r gamedata/data
	use x86 && doexe x86/"${PN}"
	use amd64 && doexe amd64/"${PN}"

	doicon gamedata/"${PN}.png"
	dodoc gamedata/README-linux.txt

	games_make_wrapper "${PN}" "./${PN}" "${dir}"
	make_desktop_entry "${PN}" "Braid" "${PN}"

	prepgamesdirs
}
