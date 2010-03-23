# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2

DESCRIPTION="Clutter based world map renderer"
HOMEPAGE="http://blog.pierlux.com/projects/libchamplain/en/"
SRC_URI=${SRC_URI/bz2/gz}

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gtk introspection"

RDEPEND=">=dev-libs/glib-2.16
	>=x11-libs/cairo-1.4
	>=net-libs/libsoup-2.26[gnome]

	media-libs/clutter:1.0
	dev-db/sqlite:3

	gtk? (
		>=x11-libs/gtk+-2.10
		>=media-libs/clutter-gtk-0.10:1.0 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.9 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.3 )"

G2CONF="${G2CONF}
	--disable-static
	$(use_enable introspection)
	$(use_enable gtk)"

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}
