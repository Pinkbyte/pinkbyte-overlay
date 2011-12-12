# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

KDE_LINGUAS="de fr"
inherit kde4-base git-2

DESCRIPTION="A KDE4 plasma widget used for monitoring servers via ping or tcp connect (Pinkbyte's fork)"
HOMEPAGE="https://gitorious.org/~pinkbyte/serverstatuswidget/pinkbyte-serverstatuswidget"
EGIT_PROJECT="pinkbyte-serverstatuswidget"
EGIT_REPO_URI="git://gitorious.org/~pinkbyte/serverstatuswidget/pinkbyte-serverstatuswidget.git"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE=""
