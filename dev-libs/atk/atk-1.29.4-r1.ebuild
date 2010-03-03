# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

EAPI=3

DESCRIPTION="GTK+ & GNOME Accessibility Toolkit"
HOMEPAGE="http://live.gnome.org/GAP/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc introspection"

RDEPEND=">=dev-libs/glib-2"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1 )
	introspection? ( dev-libs/gobject-introspection )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable introspection)"
}
