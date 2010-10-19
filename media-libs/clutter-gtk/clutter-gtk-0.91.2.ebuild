# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2 clutter

DESCRIPTION="Clutter-GTK - GTK+ Integration library for Clutter"

SLOT="1.0"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug examples +introspection"

RDEPEND="
	>=x11-libs/gtk+-2.91.1:3[introspection?]
	>=media-libs/clutter-1.2:1.0[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.3 )"
DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.14 )"
EXAMPLES="examples/{*.c,redhand.png}"

pkg_setup() {
	G2CONF="${G2CONF}
		--with-flavour=x11
		--enable-maintainer-flags=no
		$(use_enable introspection)"
}
