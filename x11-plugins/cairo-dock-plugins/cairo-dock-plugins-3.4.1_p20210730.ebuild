# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="${PN/plugins/plug-ins}"
MM_PV=$(ver_cut 1-2)

DESCRIPTION="Official plugins for cairo-dock"
HOMEPAGE="http://www.glx-dock.org"
SRC_URI="http://dev.gentoo.org/~pinkbyte/distfiles/snapshots/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa exif gmenu terminal gnote vala webkit xfce xgamma xklavier twitter indicator3 zeitgeist mail"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	gnome-base/librsvg:2
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gtkglext
	>=x11-misc/cairo-dock-3.4.1
	x11-libs/gtk+:3
	alsa? ( media-libs/alsa-lib )
	exif? ( media-libs/libexif )
	gmenu? ( gnome-base/gnome-menus )
	terminal? ( x11-libs/vte:= )
	vala? ( dev-lang/vala:= )
	webkit? ( >=net-libs/webkit-gtk-1.4.0:3 )
	xfce? ( xfce-base/thunar )
	xgamma? ( x11-libs/libXxf86vm )
	xklavier? ( x11-libs/libxklavier )
	gnote? ( app-misc/gnote )
	twitter? ( dev-python/oauth dev-python/simplejson )
	indicator3? ( dev-libs/libindicator:= )
	zeitgeist? ( dev-libs/libzeitgeist )
	mail? ( net-libs/libetpan )
"

DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	dev-libs/libdbusmenu[gtk3]
"

S="${WORKDIR}/cairo-dock-plug-ins-master"

src_prepare() {
	# fix version to compile with cairo-dock-3.4.1
	sed -i -e '/set (VERSION/s/3.4.99.alpha1/3.4.1/' CMakeLists.txt || die

	# disable broken weather plugin
	eapply "${FILESDIR}/${P}-disable-weather.patch"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-Denable-alsa-mixer=$(usex alsa)
		-Denable-sound-effects=$(usex alsa)
		# broken with 0.99.x (as of cairo-dock 3.3.2)
		-Denable-upower-support=OFF
	)
	cmake_src_configure
}
