# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils gnome2

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="http://www.gnome.org/projects/evince/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus debug djvu doc dvi gnome gnome-keyring introspection nautilus t1lib tiff"

RDEPEND="
	>=app-text/libspectre-0.2.0
	>=dev-libs/glib-2.18.0
	>=dev-libs/libxml2-2.5
	>=x11-libs/gtk+-2.14
	>=x11-libs/libSM-1
	>=x11-themes/gnome-icon-theme-2.17.1
	dbus? ( >=dev-libs/dbus-glib-0.71 )
	gnome? ( >=gnome-base/gconf-2 )
	gnome-keyring? ( >=gnome-base/gnome-keyring-2.22.0 )
	introspection? ( >=dev-libs/gobject-introspection-0.6 )
	nautilus? ( >=gnome-base/nautilus-2.10 )
	>=app-text/poppler-0.12.3-r3[cairo]
	dvi? (
		virtual/tex-base
		t1lib? ( >=media-libs/t1lib-5.0.0 ) )
	tiff? ( >=media-libs/tiff-3.6 )
	djvu? ( >=app-text/djvu-3.5.17 )"
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

G2CONF="${G2CONF}
	--disable-scrollkeeper
	--disable-static
	--disable-tests
	--enable-pdf
	--enable-comics
	--enable-impress
	--enable-thumbnailer
	--with-smclient=xsmp
	--with-platform=gnome
	$(use_enable dbus)
	$(use_enable djvu)
	$(use_enable dvi)
	$(use_with gnome gconf)
	$(use_with gnome-keyring keyring)
	$(use_enable introspection)
	$(use_enable t1lib)
	$(use_enable tiff)
	$(use_enable nautilus)"

src_prepare() {
	gnome2_src_prepare

	epatch "${FILESDIR}"/${PN}-0.7.1-display-menu.patch
	rm -v m4/lt* m4/libtool.m4 || die "removing libtool macros failed"
	if ! use gnome; then
		cp "${FILESDIR}/gconf-2.m4" m4/ || die "Copying gconf-2.m4 failed!"
	fi
	
	intltoolize --force --automake --copy || die "intltoolized failed"
	eautoreconf
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}
