# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Gnome keyboard configuration library"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-libs/glib-2.18:2
	>=x11-libs/gtk+-2.90:3
	>=x11-libs/libxklavier-5.0"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.19"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--disable-schemas-compile
		$(use_enable test tests)"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_prepare() {
	gnome2_src_prepare
	sed -i 's:gdk-x11:gtk+-x11:g' configure
}
