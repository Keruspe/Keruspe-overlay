# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2 eutils

DESCRIPTION="Gnome terminal widget"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc glade introspection python"

RDEPEND=">=dev-libs/glib-2.22.0
	>=x11-libs/gtk+-2.14.0
	>=x11-libs/pango-1.22.0
	sys-libs/ncurses
	glade? ( dev-util/glade:3 )
	python? ( >=dev-python/pygtk-2.4 )
	x11-libs/libX11
	x11-libs/libXft
	introspection? ( dev-libs/gobject-introspection
		!!dev-libs/gir-repository[vte] )"
DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.13 )
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	sys-devel/gettext"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-deprecation
		--disable-static
		$(use_enable introspection)
		$(use_enable debug)
		$(use_enable glade glade-catalogue)
		$(use_enable python)
		--with-html-dir=/usr/share/doc/${PF}/html"
}

src_prepare() {
	gnome2_src_prepare
	epatch "${FILESDIR}/${PN}-0.24.1-background-color.patch"
	epatch "${FILESDIR}/${PN}-0.24.1-cleanup-background.patch"
}