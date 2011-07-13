# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2:2.5"

inherit gnome2-live

DESCRIPTION="Provides core UI functions for the GNOME 3 desktop"
HOMEPAGE="http://live.gnome.org/GnomeShell"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="bluetooth +nm-applet +recorder"

# gnome-desktop-2.91.2 is needed due to header changes, db82a33 in gnome-desktop
# FIXME: Automagic gnome-bluetooth[introspection] support.
# latest gsettings-desktop-schemas is needed due to commit 602fa1c6
# latest g-c-c is needed due to https://bugs.gentoo.org/show_bug.cgi?id=360057
COMMON_DEPEND=">=dev-libs/glib-2.25.9:2
	>=dev-libs/gjs-0.7.11
	>=dev-libs/gobject-introspection-0.10.1
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/gtk+-3.0.0:3[introspection]
	>=media-libs/clutter-1.7.5:1.0[introspection]
	>=gnome-base/gnome-desktop-2.91.2:3
	>=gnome-base/gsettings-desktop-schemas-2.91.91
	>=gnome-extra/evolution-data-server-2.91.6[introspection]
	>=media-libs/gstreamer-0.10.16:0.10
	>=media-libs/gst-plugins-base-0.10.16:0.10
	>=net-im/telepathy-logger-0.2.4[introspection]
	>=net-libs/telepathy-glib-0.15.3[introspection]
	>=net-im/telepathy-mission-control-5.9.0
	bluetooth? ( >=net-wireless/gnome-bluetooth-3.1[introspection] )
	!bluetooth? ( !!net-wireless/gnome-bluetooth )
	>=sys-auth/polkit-0.100[introspection]
	>=x11-wm/mutter-3.1.3
	net-libs/libsoup:2.4

	dev-libs/dbus-glib
	dev-libs/libxml2:2
	x11-libs/pango[introspection]
	dev-libs/libcroco:0.6

	gnome-base/gconf:2[introspection]
	gnome-base/gnome-menus
	gnome-base/librsvg
	media-libs/libcanberra
	media-sound/pulseaudio

	x11-libs/startup-notification
	x11-libs/libX11
	x11-libs/libXfixes"
# Runtime-only deps are probably incomplete and approximate.
# Each block:
# 1. Pull in polkit-0.101 for pretty authorization dialogs
# 2. Introspection stuff + dconf needed via imports.gi.*
# 3. gnome-session is needed for gnome-session-quit
# 4. Control shell settings
# 5. nm-applet is needed for auth prompting and the wireless connection dialog
RDEPEND="${COMMON_DEPEND}
	x11-themes/gnome-icon-theme-symbolic
	x11-themes/gnome-themes-standard
	media-fonts/cantarell

	>=sys-auth/polkit-0.101[introspection]

	>=gnome-base/dconf-0.4.1
	>=gnome-base/libgnomekbd-2.91.4[introspection]
	sys-power/upower[introspection]

	>=gnome-base/gnome-session-2.91.91

	>=gnome-base/gnome-settings-daemon-2.91
	>=gnome-base/gnome-control-center-2.91.92-r1

	nm-applet? (
		>=gnome-extra/nm-applet-0.8.997
		>=net-misc/networkmanager-0.8.997[introspection] )
	recorder? ( media-plugins/gst-plugins-vp8 )"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.26
	gnome-base/gnome-common"

pkg_setup() {
	DOCS="AUTHORS README"
	# Don't error out on warnings
	G2CONF="${G2CONF}
		--enable-compile-warnings=maximum
		--disable-schemas-compile
		--disable-jhbuild-wrapper-script"
}

src_prepare() {
	epatch ${FILESDIR}/0001-whitelist-notification-stuff.patch
    gnome2_src_prepare
}
