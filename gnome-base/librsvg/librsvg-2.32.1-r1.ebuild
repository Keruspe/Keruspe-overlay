# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
GCONF_DEBUG="no"

inherit gnome2 multilib eutils autotools

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="http://librsvg.sourceforge.net/"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="doc +gtk +gtk3 tools"

RDEPEND=">=media-libs/fontconfig-1.0.1
	>=media-libs/freetype-2
	>=dev-libs/glib-2.24:2
	>=x11-libs/cairo-1.2
	>=x11-libs/pango-1.10
	>=dev-libs/libxml2-2.4.7
	>=dev-libs/libcroco-0.6.1
	|| ( x11-libs/gdk-pixbuf
		x11-libs/gtk+:2 )
	gtk? ( >=x11-libs/gtk+-2.16:2 )
	gtk3? ( >=x11-libs/gtk+-2.90:3 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12
	>=dev-util/gtk-doc-am-1.13
	doc? ( >=dev-util/gtk-doc-1 )"
# >=dev-util/gtk-doc-am-1.13 needed by eautoreconf, feel free to drop it when not run it

pkg_setup() {
	# croco is forced on to respect SVG specification
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable tools)
		--with-croco
		--enable-pixbuf-loader
		$(use_with gtk gtk2)
		$(use_with gtk3)"
	if use gtk || use gtk3; then
		G2CONF="${G2CONF} --enable-gtk-theme"
	else
		G2CONF="${G2CONF} --disable-gtk-theme"
	fi
	DOCS="AUTHORS ChangeLog README NEWS TODO"
}

src_install() {
	gnome2_src_install

	# Remove .la files, these libraries are dlopen()-ed.
	rm -vf "${ED}"/usr/lib*/gtk*/*/engines/libsvg.la
	rm -vf "${ED}"/usr/lib*/gdk-pixbuf-2.0/*/loaders/libpixbufloader-svg.la
}

pkg_postinst() {
	gdk-pixbuf-query-loaders > "${EROOT}/usr/$(get_libdir)/gdk-pixbuf-2.0/2.10.0/loaders.cache"
}

pkg_postrm() {
	gdk-pixbuf-query-loaders > "${EROOT}/usr/$(get_libdir)/gdk-pixbuf-2.0/2.10.0/loaders.cache"
}
