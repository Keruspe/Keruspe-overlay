# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2

DESCRIPTION="Unicode character map viewer"
HOMEPAGE="http://gucharmap.sourceforge.net/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cjk doc gnome introspection python test"

RDEPEND=">=dev-libs/glib-2.16.3
	>=x11-libs/pango-1.2.1
	>=x11-libs/gtk+-2.13.6
	gnome? ( gnome-base/gconf )
	python? ( >=dev-python/pygtk-2.7.1 )"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	>=app-text/gnome-doc-utils-0.9.0
	doc? ( >=dev-util/gtk-doc-1.0 )
	introspection? ( dev-libs/gobject-introspection )
	test? ( ~app-text/docbook-xml-dtd-4.1.2 )"

DOCS="ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-maintainer-mode
		$(use_enable introspection)
		$(use_enable gnome gconf)
		$(use_enable cjk unihan)
		$(use_enable python python-bindings)"
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}
