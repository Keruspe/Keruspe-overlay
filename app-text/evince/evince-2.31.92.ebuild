# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils gnome2

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="http://www.gnome.org/projects/evince/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="dbus debug djvu doc dvi gnome gnome-keyring gtk3 images +introspection nautilus t1lib tiff"

RDEPEND="
	>=app-text/libspectre-0.2.0
	>=dev-libs/glib-2.25.11
	>=dev-libs/libxml2-2.5
	gtk3? (	>=x11-libs/gtk+-2.90.5:3[introspection?] )
	!gtk3? ( >=x11-libs/gtk+-2.21.5:2[introspection?] )
	>=x11-libs/libSM-1
	>=x11-themes/gnome-icon-theme-2.17.1
	gnome? ( >=gnome-base/gconf-2[introspection?] )
	gnome-keyring? ( >=gnome-base/gnome-keyring-2.22.0 )
	nautilus? ( >=gnome-base/nautilus-2.10[introspection?] )
	>=app-text/poppler-0.14[cairo]
	dvi? (
		virtual/tex-base
		t1lib? ( >=media-libs/t1lib-5.0.0 ) )
	tiff? ( >=media-libs/tiff-3.6 )
	djvu? ( >=app-text/djvu-3.5.17 )
	introspection? ( >=dev-libs/gobject-introspection-0.6 )"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.3.2
	~app-text/docbook-xml-dtd-4.1.2
	>=dev-util/pkgconfig-0.9
	sys-devel/gettext
	>=dev-util/intltool-0.35
	dev-util/gtk-doc-am
	doc? ( dev-util/gtk-doc )"

DOCS="AUTHORS ChangeLog NEWS README TODO"
ELTCONF="--portage"

RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-static
		--disable-tests
		--enable-pdf
		--enable-ps
		--enable-comics
		--disable-impress
		--enable-thumbnailer
		--with-smclient=xsmp
		--with-platform=gnome
		$(use_enable dbus)
		$(use_enable djvu)
		$(use_enable dvi)
		$(use_with gnome gconf)
		$(use_with gnome-keyring keyring)
		$(use_enable t1lib)
		$(use_enable tiff)
		$(use_enable nautilus)
		$(use_enable images pixbuf)
		$(use_enable introspection)"
	
		if use gtk3; then
			G2CONF="${G2CONF} --with-gtk=3.0"
		else
			G2CONF="${G2CONF} --with-gtk=2.0"
		fi
}

src_prepare() {
	gnome2_src_prepare
	epatch "${FILESDIR}"/${PN}-0.7.1-display-menu.patch
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}
