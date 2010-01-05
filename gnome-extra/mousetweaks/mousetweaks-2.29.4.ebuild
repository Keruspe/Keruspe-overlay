# Copyright 1999-2010 Gentoo Foundation
# Copyright 2009-2010 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2

DESCRIPTION="Mouse accessibility enhancements for the GNOME desktop"
HOMEPAGE="http://live.gnome.org/Mousetweaks/Home"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="applet"

RDEPEND=">=x11-libs/gtk+-2.16
	>=gnome-base/gconf-2.16
	>=dev-libs/dbus-glib-0.72
	applet? ( >=gnome-base/gnome-panel-2 )
	gnome-extra/at-spi

	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXfixes
	x11-libs/libXcursor"
DEPEND="${RDEPEND}
	  gnome-base/gnome-common
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.17"

pkg_setup() {
	G2CONF="${G2CONF}
	$(use_enable applet pointer-capture)
	$(use_enable applet dwell-click)"
}
