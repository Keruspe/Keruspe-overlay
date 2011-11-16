# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2-live

DESCRIPTION="VNC Client for the GNOME Desktop"
HOMEPAGE="http://www.gnome.org/projects/vinagre/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="avahi +ssh +telepathy test"

# cairo used in vinagre-tab
# gdk-pixbuf used all over the place
RDEPEND=">=dev-libs/glib-2.28.0:2
	>=x11-libs/gtk+-3.0.3:3
	>=gnome-base/gnome-keyring-1
	>=dev-libs/libxml2-2.6.31:2
	>=net-libs/gtk-vnc-0.4.3[gtk3]
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-themes/gnome-icon-theme

	avahi? ( >=net-dns/avahi-0.6.26[dbus,gtk3] )
	ssh? ( >=x11-libs/vte-0.20:2.90 )
	telepathy? (
		dev-libs/dbus-glib
		>=net-libs/telepathy-glib-0.11.6 )
"
DEPEND="${RDEPEND}
	dev-lang/vala:0.14
	gnome-base/gnome-common
	>=dev-lang/perl-5
	>=dev-util/pkgconfig-0.16
	>=dev-util/intltool-0.40
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	>=sys-devel/gettext-0.17
	test? ( ~app-text/docbook-xml-dtd-4.3 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog ChangeLog.pre-git NEWS README"
	# Spice support?
	# SSH support fails to compile
	G2CONF="${G2CONF}
		VALAC=$(type -p valac-0.14)
		--disable-schemas-compile
		--disable-scrollkeeper
		--disable-spice
		--enable-rdp
		$(use_with avahi)
		$(use_enable ssh)
		$(use_with telepathy)"
}

src_install() {
	gnome2_src_install

	# Remove it's own installation of DOCS that go to $PN instead of $P and aren't ecompressed
	rm -rf "${ED}"/usr/share/doc/vinagre
}
