# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils git gnome2 multilib

DESCRIPTION="Gnome keyboard configuration library"
HOMEPAGE="http://www.gnome.org"
SRC_URI=""
EGIT_REPO_URI="git://git.gnome.org/libgnomekbd"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.18
	>=sys-apps/dbus-0.92
	>=dev-libs/dbus-glib-0.34
	>=gnome-base/gconf-2.14
	>=x11-libs/gtk+-2.91:3
	>=x11-libs/libxklavier-5.0"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.19"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} --disable-tests --disable-static"
}

src_unpack() {
	git_src_unpack
}

src_prepare() {
	gnome2_src_prepare
	eautoreconf
}
