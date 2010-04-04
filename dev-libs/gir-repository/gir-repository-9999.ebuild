# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools gnome2 git

DESCRIPTION="Gobject-Introspection file Repository"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"
EGIT_REPO_URI="git://git.gnome.org/gir-repository"
SRC_URI=""

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="avahi babl dbus gconf gnome-keyring goocanvas gtksourceview
gupnp libnotify libsoup nautilus pango poppler vte"

RDEPEND=">=dev-libs/gobject-introspection-0.6.5"
DEPEND="${RDEPEND}
	avahi? ( >=net-dns/avahi-0.6 )
	babl? ( =media-libs/babl-0.0 )
	dbus? ( dev-libs/dbus-glib )
	gconf? ( gnome-base/gconf )
	gnome-keyring? ( gnome-base/gnome-keyring )
	goocanvas? ( x11-libs/goocanvas )
	gtksourceview? ( x11-libs/gtksourceview )
	gupnp? (
		net-libs/gssdp
		net-libs/gupnp )
	libnotify? ( x11-libs/libnotify )
	libsoup? ( net-libs/libsoup:2.4 )
	nautilus? ( gnome-base/nautilus )
	poppler? ( >=app-text/poppler-0.12.3-r3 )
	vte? ( x11-libs/vte )
"

pkg_setup() {
	SKIP="Atk,GMenu,Gnio,Gst,Gtk,Pango,PangoXft,WebKit,Wnck,Unique"
	use !avahi && SKIP="${SKIP},Avahi"
	use !babl && SKIP="${SKIP},BABL"
	use !dbus && SKIP="${SKIP},DBus"
	use !gconf && SKIP="${SKIP},GConf"
	use !gnome-keyring && SKIP="${SKIP},GnomeKeyring"
	use !goocanvas && SKIP="${SKIP},GooCanvas"
	use !gtksourceview && SKIP="${SKIP},GTKSOURCEVIEW"
	use !gupnp && SKIP="${SKIP},GUPNP"
	use !libnotify && SKIP="${SKIP},Notify"
	use !libsoup && SKIP="${SKIP},Soup"
	use !nautilus && SKIP="${SKIP},Nautilus"
	use !poppler && SKIP="${SKIP},Poppler"
	use !vte && SKIP="${SKIP},Vte"

	G2CONF="${G2CONF} --with-skipped-gir-modules=${SKIP}"
}

src_unpack() {
	git_src_unpack	
	cd ${S}
	eautoreconf
}
