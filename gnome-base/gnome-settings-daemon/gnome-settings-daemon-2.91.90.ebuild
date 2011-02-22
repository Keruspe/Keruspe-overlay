# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit autotools eutils gnome2

DESCRIPTION="Gnome Settings Daemon"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug packagekit policykit smartcard +udev"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.26.0
	>=x11-libs/gtk+-2.99.3:3
	>=gnome-base/gconf-2.6.1
	>=gnome-base/libgnomekbd-2.91.1
	>=gnome-base/gnome-desktop-2.91.5:3
	>=gnome-base/gsettings-desktop-schemas-0.1.2
	media-fonts/cantarell
	media-libs/fontconfig

	>=x11-libs/libnotify-0.6.1
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXxf86misc
	>=x11-libs/libxklavier-5.0
	>=media-sound/pulseaudio-0.9.16
	media-libs/libcanberra[gtk3]

	packagekit? (
		dev-libs/glib:2
		>=app-portage/packagekit-0.6.4
		>=sys-power/upower-0.9.1 )
	policykit? (
		>=sys-auth/polkit-0.97
		>=sys-apps/dbus-1.1.2 )
	smartcard? ( >=dev-libs/nss-3.11.2 )
	udev? ( sys-fs/udev[extras] )"
RDEPEND="${COMMON_DEPEND}
	>=x11-themes/gnome-themes-standard-2.91
	>=x11-themes/gnome-icon-theme-2.91
	>=x11-themes/gnome-icon-theme-symbolic-2.91"
DEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-control-center-2.22
	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.19
	x11-proto/inputproto
	x11-proto/xproto"

pkg_setup() {
	DOCS="AUTHORS NEWS ChangeLog MAINTAINERS"
	G2CONF="${G2CONF}
		--disable-static
		--disable-schemas-compile
		--enable-gconf-bridge
		$(use_enable debug)
		$(use_enable packagekit)
		$(use_enable policykit polkit)
		$(use_enable smartcard smartcard-support)
		$(use_enable udev gudev)"
}

src_install() {
	gnome2_src_install

	echo 'GSETTINGS_BACKEND="dconf"' >> 51gsettings-dconf
	doenvd 51gsettings-dconf || die "doenvd failed"
}
