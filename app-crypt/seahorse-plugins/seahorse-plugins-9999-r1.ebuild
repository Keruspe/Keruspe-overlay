# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2-live

DESCRIPTION="A GNOME application for managing encryption keys"
HOMEPAGE="http://www.gnome.org/projects/seahorse/index.html"

LICENSE="GPL-2"
SLOT="0"
IUSE="applet debug gedit libnotify nautilus test"
KEYWORDS=""

# Note: always support only the latest gedit
RDEPEND="
	>=dev-libs/glib-2.16
	>=gnome-base/gconf-2.0
	>=x11-libs/gtk+-2.90.0:3
	>=dev-libs/dbus-glib-0.72
	>=app-crypt/gpgme-1.0.0
	>=app-crypt/seahorse-2.91
	>=x11-libs/libcryptui-3.1.4
	>=gnome-base/gnome-keyring-2.25

	|| (
		=app-crypt/gnupg-1.4*
		=app-crypt/gnupg-2.0* )

	nautilus? ( >=gnome-base/nautilus-2.12 )
	gedit? ( >=app-editors/gedit-2.20 )
	applet? ( >=gnome-base/gnome-panel-2.31.2 )
	libnotify? ( >=x11-libs/libnotify-0.3.2 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=app-text/gnome-doc-utils-0.3.2
	>=app-text/scrollkeeper-0.3
	>=dev-util/pkgconfig-0.20
	>=dev-util/intltool-0.35"

src_prepare() {
	G2CONF="${G2CONF}
		--enable-agent
		--disable-update-mime-database
		--disable-static
		--disable-epiphany
		--with-gtk=3.0
		$(use_enable applet)
		$(use_enable debug)
		$(use_enable gedit)
		$(use_enable libnotify)
		$(use_enable nautilus)
		$(use_enable test tests)"
	gnome2_src_prepare
}
