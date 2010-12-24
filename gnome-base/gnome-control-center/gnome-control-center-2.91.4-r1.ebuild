# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=3
inherit gnome2

DESCRIPTION="The gnome2 Desktop configuration tool"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="x11-libs/libXft
	>=x11-libs/libXi-1.2
	>=x11-libs/gdk-pixbuf-2.23.0
	>=x11-libs/gtk+-2.91.6:3
	>=dev-libs/glib-2.25.11
	>=gnome-base/gsettings-desktop-schemas-0.1.3
	>=gnome-base/gconf-2.0
	>=dev-libs/dbus-glib-0.73
	>=x11-libs/libxklavier-4.0
	>=gnome-base/libgnomekbd-2.91.0
	>=gnome-base/gnome-desktop-2.91.2:3
	>=gnome-base/gnome-menus-2.11.1
	>=gnome-base/gnome-settings-daemon-2.91
	gnome-base/accountsservice

	app-admin/apg
	x11-libs/pango
	app-text/iso-codes
	dev-libs/libxml2
	media-libs/fontconfig
	>=media-libs/libcanberra-0.13[gtk3]
	>=media-sound/pulseaudio-0.9.16
	>=sys-power/upower-0.9.1
	>=sys-auth/polkit-0.97
	>=media-video/cheese-2.29.90
	media-libs/gstreamer:0.10

	x11-apps/xmodmap
	x11-libs/libX11
	x11-libs/libXxf86misc"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto

	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.19

	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.10.1
	doc? ( >=dev-utils/gtk-doc-1.9 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-update-mimedb
		--disable-static
		--disable-schemas-install"
	DOCS="AUTHORS ChangeLog NEWS README TODO"
}

src_install() {
	gnome2_src_install
	find "${ED}" -name "*.la" -delete || die "remove of la files failed"
}
