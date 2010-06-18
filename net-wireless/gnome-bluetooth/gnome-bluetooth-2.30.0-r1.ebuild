# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2

DESCRIPTION="Fork of bluez-gnome focused on integration with GNOME"
HOMEPAGE="http://live.gnome.org/GnomeBluetooth"
LICENSE="GPL-2 LGPL-2.1"
SLOT="2"
IUSE="doc introspection nautilus"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND=">=dev-libs/glib-2.19.1
	>=x11-libs/gtk+-2.19.1
	>=x11-libs/libnotify-0.4.3
	>=gnome-base/gconf-2.6
	>=dev-libs/dbus-glib-0.74
	dev-libs/libunique
	nautilus? ( >=gnome-extra/nautilus-sendto-2.28.0.1[-bluetooth] )"
RDEPEND="${COMMON_DEPEND}
	>=net-wireless/bluez-4.34
	app-mobilephone/obexd"
DEPEND="${COMMON_DEPEND}
	!!net-wireless/bluez-gnome
	app-text/gnome-doc-utils
	app-text/scrollkeeper
	dev-libs/libxml2
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext
	x11-libs/libX11
	x11-libs/libXi
	x11-proto/xproto
	gnome-base/gnome-common
	dev-util/gtk-doc-am
	introspection? ( dev-libs/gobject-introspection )
	doc? ( >=dev-util/gtk-doc-1.9 )"

DOCS="AUTHORS README NEWS ChangeLog"
G2CONF="${G2CONF}
--disable-desktop-update
--disable-icon-update
--disable-introspection
$(use_enable nautilus-sendto)"
#$(use_enable introspection)" needs dbus-glib[introspection] which doesn't exist

src_prepare() {
	gnome2_src_prepare
	epatch "${FILESDIR}/${P}-add-pin.patch"
	epatch "${FILESDIR}/${P}-mounted-failure.patch"
}
