# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools git gnome2 eutils

MY_PN="${PN/nm-applet/network-manager-applet}"

DESCRIPTION="Gnome applet for NetworkManager."
HOMEPAGE="http://projects.gnome.org/NetworkManager/"
SRC_URI=""
EGIT_REPO_URI="git://git.gnome.org/network-manager-applet"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth"

RDEPEND=">=dev-libs/glib-2.16
	>=dev-libs/dbus-glib-0.74
	>=sys-apps/dbus-1.2.6
	>=x11-libs/gtk+-2.91.4:3
	>=gnome-base/gconf-2.20
	>=gnome-extra/polkit-gnome-0.92
	>=x11-libs/libnotify-0.7.0
	>=gnome-base/gnome-keyring-2.20

	>=dev-libs/libnl-1.1
	>=net-misc/networkmanager-0.8.2
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

pkg_setup() {
	G2CONF="${G2CONF}
		--without-gtk2
		--disable-more-warnings
		--localstatedir=/var"
}

src_unpack() {
	git_src_unpack
}

src_prepare() {
	gnome2_src_prepare
	eautoreconf
	intltoolize --automake
}
