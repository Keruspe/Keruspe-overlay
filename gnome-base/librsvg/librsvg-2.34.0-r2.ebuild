# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"
GCONF_DEBUG="no"

inherit gnome2 multilib eutils autotools

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="http://librsvg.sourceforge.net/"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc +gtk gtk3 tools"

RDEPEND=">=media-libs/fontconfig-1.0.1
	>=media-libs/freetype-2
	>=dev-libs/glib-2.24:2
	>=x11-libs/cairo-1.2
	>=x11-libs/pango-1.10
	>=dev-libs/libxml2-2.4.7:2
	>=dev-libs/libcroco-0.6.1
	|| ( x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2 )
	gtk? ( >=x11-libs/gtk+-2.16:2 )
	gtk3? ( >=x11-libs/gtk+-2.90.0:3 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12
	doc? ( >=dev-util/gtk-doc-1.13 )"
# >=dev-util/gtk-doc-am-1.13 needed by eautoreconf

pkg_setup() {
	# croco is forced on to respect SVG specification
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable tools)
		$(use_enable gtk gtk-theme)
		--with-croco
		--enable-pixbuf-loader"
	use gtk && ! use gtk3 && G2CONF+=" --with-gtk=2.0"
	use gtk && use gtk3 && G2CONF+=" --with-gtk=both"
	! use gtk && use gtk3 && G2CONF+=" --with-gtk=3.0 --enable-gtk-theme"

	DOCS="AUTHORS ChangeLog README NEWS TODO"
}

src_prepare() {
	epatch ${FILESDIR}/fix-g_const.patch
	gnome2-src_prepare

	# Fix automagic gtk+ dependency, bug #371290
	epatch "${FILESDIR}/${PN}-2.34.0-automagic-gtk.patch"
	eautoreconf
}

pkg_postinst() {
	gdk-pixbuf-query-loaders > "${EROOT}/usr/$(get_libdir)/gdk-pixbuf-2.0/2.10.0/loaders.cache"
}

pkg_postrm() {
	gdk-pixbuf-query-loaders > "${EROOT}/usr/$(get_libdir)/gdk-pixbuf-2.0/2.10.0/loaders.cache"
}
