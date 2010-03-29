# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils gnome2

DESCRIPTION="Gnome Settings Daemon"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug libnotify pulseaudio"

RDEPEND=">=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.18.0
	>=x11-libs/gtk+-2.16
	>=gnome-base/gconf-2.6.1
	>=gnome-base/libgnomekbd-2.29.5
	>=gnome-base/gnome-desktop-2.29.5

	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXext
	x11-libs/libXxf86misc
	>=x11-libs/libxklavier-4.0
	media-libs/fontconfig

	libnotify? ( >=x11-libs/libnotify-0.4.3 )
	pulseaudio? (
		>=media-sound/pulseaudio-0.9.15
		media-libs/libcanberra[gtk] )"
DEPEND="${RDEPEND}
	!<gnome-base/gnome-control-center-2.29
	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.19
	x11-proto/inputproto
	x11-proto/xproto"

DOCS="AUTHORS NEWS ChangeLog MAINTAINERS"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable debug)
		$(use_with libnotify)
		$(use_enable pulseaudio pulse)"

	if use pulseaudio; then
		elog "Building volume media keys using Pulseaudio"
	fi
}

src_prepare() {
	gnome2_src_prepare
	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}
