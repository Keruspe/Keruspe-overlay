# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.4"
inherit gnome2 multilib python

DESCRIPTION="Telepathy client and library using GTK+"
HOMEPAGE="http://live.gnome.org/Empathy"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="eds map nautilus networkmanager spell test webkit" #webkit needs webkit-gtk3

RDEPEND=">=dev-libs/glib-2.27.2:2
	>=x11-libs/gtk+-2.91.3:3
	eds? ( >=gnome-extra/evolution-data-server-1.2 )
	>=net-libs/telepathy-glib-0.13.7
	>=media-libs/libcanberra-0.4[gtk]
	>=x11-libs/libnotify-0.7.0
	>=gnome-base/gnome-keyring-2.91.1
	>=net-libs/gnutls-2.8.5
	>=dev-libs/folks-0.3.3

	net-libs/farsight2
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	>=net-libs/telepathy-farsight-0.0.14
	dev-libs/libxml2
	x11-libs/libX11
	net-voip/telepathy-connection-managers
	>=net-im/telepathy-logger-0.1.5

	map? (
		>=media-libs/clutter-gtk-0.10:1.0 
		>=gnome-extra/geoclue-0.11.1 )
	nautilus? ( >=gnome-extra/nautilus-sendto-2.90.0 )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	spell? (
		>=app-text/enchant-1.2
		>=app-text/iso-codes-0.35 )"
#	>=media-libs/libchamplain-0.7.1[gtk] need gtk3
#	webkit? ( >=net-libs/webkit-gtk-1.1.15 )"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.17.3
	>=dev-util/intltool-0.35.0
	>=dev-util/pkgconfig-0.16
	test? (
		sys-apps/grep
		>=dev-libs/check-0.9.4 )
	dev-libs/libxslt
"
PDEPEND=">=net-im/telepathy-mission-control-5"

DOCS="CONTRIBUTORS AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-static
		--disable-Werror
		--disable-gtk3
		$(use_enable debug)
		$(use_with eds)
		$(use_enable map location)
		$(use_enable nautilus nautilus-sendto)
		$(use_with networkmanager connectivity nm)
		$(use_enable spell)
		$(use_enable test coding-style-checks)
		$(use_enable webkit)"
		#$(use_enable map) needs champlain-gtk3
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
