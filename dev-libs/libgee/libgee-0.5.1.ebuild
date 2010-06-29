# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2

DESCRIPTION="GObject-based interfaces and classes for commonly used data structures."
HOMEPAGE="http://live.gnome.org/Libgee"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="introspection"

RDEPEND=">=dev-libs/glib-2.12
	introspection? ( dev-libs/gobject-introspection )"
DEPEND="${RDEPEND}
	dev-lang/vala
	dev-util/pkgconfig"

G2CONF="${G2CONF} $(use_enable introspection)"
