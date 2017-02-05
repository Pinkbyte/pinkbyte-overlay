# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO: unbundle libSDL2

EAPI=5

inherit eutils gnome2-utils unpacker games

TIMESTAMP="${PV:4:2}${PV:6:2}${PV:0:4}"
DESCRIPTION="Ghost story, told using first-person gaming technologies"
HOMEPAGE="http://dear-esther.com/"
SRC_URI="dearesther-linux-${TIMESTAMP}-bin
	linguas_ru? ( http://www.dear-esther.com/translations/DE_Russian.rar )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="linguas_ru"
RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/dearesther_linux
	${MYGAMEDIR#/}/bin/*.so*"

DEPEND="
	app-arch/unzip
	app-arch/unrar
"
RDEPEND="
	>=media-libs/freetype-2.5.0.1[abi_x86_32(-)]
	>=media-libs/libsdl-1.2.15-r5[abi_x86_32(-)]
	>=media-libs/openal-1.15.1[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
"

S=${WORKDIR}/data

pkg_nofetch() {
	einfo "Please buy & download dearesther-linux-${TIMESTAMP}-bin from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	einfo
	if use linguas_ru; then
		einfo "Also, please download http://www.dear-esther.com/translations/DE_Russian.rar"
		einfo "if you want full russian localization"
		einfo
	fi
}

src_unpack() {
	unpack_zip "dearesther-linux-${TIMESTAMP}-bin"
	if use linguas_ru; then
		mkdir "${WORKDIR}/russian" || die
		pushd "${WORKDIR}/russian" &>/dev/null || die
		unrar e "${DISTDIR}/DE_Russian.rar" || die 'unpacking of russian localization failed'
		rm *.rtf || die 'remove uneeded guide'
		# Workaround to broken subtitle support
		mv closecaption_{russian,english}.txt || die
		mv closecaption_{russian,english}.dat || ide
		#
		mv * "${WORKDIR}/data/dearesther/resource" || die
		popd &>/dev/null
	fi
}

src_install() {
	insinto "${MYGAMEDIR}"
	doins -r bin dearesther platform dearesther_linux

	doicon -s 256 dearesther.png
	make_desktop_entry "${PN}" "Dear Esther" dearesther
	if use linguas_ru; then
		games_make_wrapper ${PN} "./dearesther_linux -game dearesther -language russian" "${MYGAMEDIR}" "${MYGAMEDIR}/bin"
	else
		games_make_wrapper ${PN} "./dearesther_linux -game dearesther" "${MYGAMEDIR}" "${MYGAMEDIR}/bin"
	fi

	dodoc README-linux.txt

	fperms +x "${MYGAMEDIR}"/dearesther_linux

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
