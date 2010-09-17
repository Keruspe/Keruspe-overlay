# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2 eutils

DESCRIPTION="A library providing GLib serialization and deserialization support for the JSON format"
HOMEPAGE="http://live.gnome.org/JsonGlib"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="doc +introspection"

RDEPEND=">=dev-libs/glib-2.25"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.11 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable introspection)"
}
