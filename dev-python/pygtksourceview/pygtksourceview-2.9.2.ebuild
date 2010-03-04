# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2 flag-o-matic multilib

DESCRIPTION="GTK+2 bindings for Python"
HOMEPAGE="http://www.pygtk.org/"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-python/pygobject-2.15.2
	>=dev-python/pygtk-2.8
	>=x11-libs/gtksourceview-2.8.1"

DEPEND="${RDEPEND}
	doc? (
		>=dev-util/gtk-doc-1.10
		dev-libs/libxslt
		~app-text/docbook-xml-dtd-4.1.2
		>=app-text/docbook-xsl-stylesheets-1.70.1 )
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable doc docs)"
}
