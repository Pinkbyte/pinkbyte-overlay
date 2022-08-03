# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="${PN}-core"
MM_PV=$(ver_cut '1-2')

DESCRIPTION="Cairo-dock is a fast, responsive, Mac OS X-like dock."
HOMEPAGE="http://www.glx-dock.org"
SRC_URI="http://launchpad.net/${MY_PN}/${MM_PV}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt xcomposite desktop_manager"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2:2
	gnome-base/librsvg:2
	net-misc/curl
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/pango
	x11-libs/gtkglext
	x11-libs/libXrender
	x11-libs/gtk+:3
	crypt? ( sys-libs/glibc )
	xcomposite? (
		x11-libs/libXcomposite
		x11-libs/libXinerama
		x11-libs/libXtst
	)
"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
"

src_prepare() {
	# We will install man files manually
	sed -i -e '/add_subdirectory(man)/d' data/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(use desktop_manager && echo "-Denable-desktop-manager=ON" || echo "-Denable-desktop-manager=OFF")
		-DCMAKE_INSTALL_MANDIR="/usr/share/man/${PV}"
	)
	cmake_src_configure
}

src_install() {
	newman data/man/cairo-dock_en.1 cairo-dock_en.1
	cmake_src_install
}

pkg_postinst() {
	elog "Additional plugins are available to extend the functionality"
	elog "of Cairo-Dock. It is recommended to install at least"
	elog "x11-pluings/cairo-dock-plugins."
	elog
	elog "Cairo-Dock is an app that draws on a RGBA GLX visual."
	elog "Some users have noticed that if the dock is launched,"
	elog "severals qt4-based applications could crash, like skype or vlc."
	elog "If you have this problem, add the following line into your bashrc :"
	echo
	elog "alias vlc='export XLIB_SKIP_ARGB_VISUALS=1; vlc; unset XLIB_SKIP_ARGB_VISUALS'"
	elog "see http://www.qtforum.org/article/26669/qt4-mess-up-the-opengl-context.html for more details."
}
