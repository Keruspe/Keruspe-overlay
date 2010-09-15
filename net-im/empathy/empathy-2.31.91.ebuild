# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools gnome2

DESCRIPTION="Telepathy client and library using GTK+"
HOMEPAGE="http://live.gnome.org/Empathy"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="eds gtk3 map nautilus-sendto networkmanager spell test webkit"

RDEPEND=">=dev-libs/glib-2.16.0
	!gtk3? ( >=x11-libs/gtk+-2.21.6:2 )
	gtk3? ( >=x11-libs/gtk+-2.90.7:3 )
	>=gnome-base/gconf-2
	>=dev-libs/dbus-glib-0.51
	eds? ( >=gnome-extra/evolution-data-server-1.2 )
	>=net-libs/telepathy-glib-0.11.15
	>=media-libs/libcanberra-0.4[gtk]
	>=x11-libs/libnotify-0.5.1
	>=gnome-base/gnome-keyring-2.22

	nautilus-sendto? ( gnome-extra/nautilus-sendto )
	dev-libs/libunique:3
	net-libs/farsight2
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	net-libs/telepathy-farsight
	dev-libs/libxml2
	x11-libs/libX11
	net-voip/telepathy-connection-managers

	map? (
		>=media-libs/libchamplain-0.7.1
		>=media-libs/clutter-gtk-0.10:1.0 
		>=gnome-extra/geoclue-0.11.1 )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	spell? (
		app-text/enchant
		app-text/iso-codes )
	webkit? ( >=net-libs/webkit-gtk-1.3.3:3.0 )
"
DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.17.3
	>=dev-util/intltool-0.35.0
	>=dev-util/pkgconfig-0.16
	>=net-im/telepathy-logger-0.1.5
	test? (
		sys-apps/grep
		>=dev-libs/check-0.9.4 )
	dev-libs/libxslt
	virtual/python
	>=net-libs/folks-0.1.15
"
PDEPEND=">=net-im/telepathy-mission-control-5"

DOCS="CONTRIBUTORS AUTHORS ChangeLog NEWS README"

MAKEOPTS="-j1"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-static
		$(use_with eds)
		$(use_enable map)
		$(use_enable map location)
		$(use_enable nautilus-sendto)
		$(use_with networkmanager connectivity nm)
		$(use_enable spell)
		$(use_enable test coding-style-checks)
		$(use_enable webkit)
		$(use_enable gtk3)
	"
	if use gtk3; then
		G2GONF+="--disable-map"
	fi
}

src_prepare() {
	sed -i "s:-Werror::g" configure || die "sed 1 failed"
	gnome2_src_prepare
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check || die "emake check failed."
}

pkg_postinst() {
	gnome2_pkg_postinst
	echo
	elog "Empathy needs telepathy's connection managers to use any IM protocol."
	elog "See the USE flags on net-voip/telepathy-connection-managers"
	elog "to install them."
}
