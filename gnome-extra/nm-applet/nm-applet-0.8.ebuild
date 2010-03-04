# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2 eutils

MY_PN="${PN/nm-applet/network-manager-applet}"

DESCRIPTION="Gnome applet for NetworkManager."
HOMEPAGE="http://projects.gnome.org/NetworkManager/"
SRC_URI="${SRC_URI//${PN}/${MY_PN}}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth"

RDEPEND=">=dev-libs/glib-2.16
	>=dev-libs/dbus-glib-0.74
	>=sys-apps/dbus-1.2
	>=x11-libs/gtk+-2.14
	>=gnome-base/gconf-2.20
	>=gnome-extra/polkit-gnome-0.92
	>=x11-libs/libnotify-0.4.3
	>=gnome-base/libglade-2
	>=gnome-base/gnome-keyring-2.20

	>=dev-libs/libnl-1.1
	>=net-misc/networkmanager-${PV}
	>=net-wireless/wireless-tools-28_pre9
	>=net-wireless/wpa_supplicant-0.5.7
	|| ( gnome-base/gnome-shell >=gnome-base/gnome-panel-2 xfce-base/xfce4-panel x11-misc/trayer )
	net-misc/mobile-broadband-provider-info
	bluetooth? ( >=net-wireless/gnome-bluetooth-2.27.6 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog NEWS README"

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup () {
	G2CONF="${G2CONF}
		--disable-more-warnings
		--localstatedir=/var"
}
