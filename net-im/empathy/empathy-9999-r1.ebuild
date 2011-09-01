# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2:2.4"

EGIT_HAS_SUBMODULES="yes"
inherit eutils gnome2-live multilib python

DESCRIPTION="Telepathy client and library using GTK+"
HOMEPAGE="http://live.gnome.org/Empathy"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="eds +map +geoloc +networkmanager sendto spell test +video webkit"

RDEPEND=">=dev-libs/glib-2.28:2
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.0.2:3
	x11-libs/pango
	>=dev-libs/dbus-glib-0.51
	>=dev-libs/folks-0.6.0
	dev-libs/libgee
	>=gnome-base/gnome-keyring-2.91.4-r300
	>=media-libs/libcanberra-0.25[gtk3]
	media-sound/pulseaudio[glib]
	>=net-libs/gnutls-2.8.5
	>=net-libs/telepathy-glib-0.15.5
	>=x11-libs/libnotify-0.7

	dev-libs/libxml2:2
	gnome-base/gsettings-desktop-schemas
	media-libs/clutter:1.0
	media-libs/clutter-gst:1.0
	>=media-libs/gstreamer-0.10.32:0.10
	media-libs/gst-plugins-base:0.10
	media-libs/gst-plugins-bad
	>=net-im/telepathy-logger-0.2.10
	net-libs/farsight2
	>=net-libs/telepathy-farsight-0.0.14
	net-libs/telepathy-farstream
	net-voip/telepathy-connection-managers
	x11-libs/libX11

	eds? ( >=gnome-extra/evolution-data-server-1.2 )
	geoloc? ( >=app-misc/geoclue-0.11 )
	map? ( media-libs/libchamplain:0.10[gtk]
		>=media-libs/clutter-gtk-0.90.3:1.0 )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	sendto? ( >=gnome-extra/nautilus-sendto-2.90.0 )
	spell? (
		>=app-text/enchant-1.2
		>=app-text/iso-codes-0.35 )
	video? (
		|| ( sys-fs/udev[gudev] sys-fs/udev[extras] )
		>=media-video/cheese-2.91.91.1 )
	webkit? ( >=net-libs/webkit-gtk-1.5.2:3 )
"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.17.3
	>=dev-util/intltool-0.35.0
	>=dev-util/pkgconfig-0.16
	>=sys-devel/gettext-0.17
	test? (
		sys-apps/grep
		>=dev-libs/check-0.9.4 )
	dev-libs/libxslt
"
PDEPEND=">=net-im/telepathy-mission-control-5.7.6"

pkg_setup() {
	DOCS="CONTRIBUTORS AUTHORS ChangeLog NEWS README"
	# TODO: Re-add location support
	G2CONF="${G2CONF}
		--disable-coding-style-checks
		--disable-schemas-compile
		--disable-static
		--disable-meego
		--disable-Werror
		--enable-call
		--disable-control-center-embedding
		$(use_enable debug)
		$(use_with eds)
		$(use_enable geoloc location)
		$(use_enable map)
		$(use_with networkmanager connectivity nm)
		$(use_enable sendto nautilus-sendto)
		$(use_enable spell)
		$(use_enable webkit)
		$(use_with video cheese)
		$(use_enable video gudev)"

	# Build time python tools needs python2
	python_set_active_version 2
}

src_prepare() {
	cd telepathy-yell
	eautoreconf
	cd ..
	gnome2_src_prepare

	python_convert_shebangs -r 2 tools
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check || die "emake check failed."
}

pkg_postinst() {
	gnome2_pkg_postinst
	elog "Empathy needs telepathy's connection managers to use any IM protocol."
	elog "See the USE flags on net-voip/telepathy-connection-managers"
	elog "to install them."
}
