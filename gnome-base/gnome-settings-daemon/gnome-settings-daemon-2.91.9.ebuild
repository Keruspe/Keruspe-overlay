# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit autotools eutils gnome2

DESCRIPTION="Gnome Settings Daemon"
HOMEPAGE="http://www.gnome.org"
SRC_URI="${SRC_URI}
	mirror://gentoo/${PN}-2.30.0-gst-vol-control-support.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug policykit pulseaudio smartcard"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.26.0
	>=x11-libs/gtk+-2.99.3:3
	>=gnome-base/gconf-2.6.1
	>=gnome-base/libgnomekbd-2.91.1
	>=gnome-base/gnome-desktop-2.91.5:3
	>=gnome-base/gsettings-desktop-schemas-0.1.2
	media-libs/fontconfig

	>=x11-libs/libnotify-0.6.1
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXxf86misc
	>=x11-libs/libxklavier-5.0

	policykit? (
		>=sys-auth/polkit-0.97
		>=sys-apps/dbus-1.1.2 )
	pulseaudio? (
		>=media-sound/pulseaudio-0.9.16
		media-libs/libcanberra[gtk] )
	!pulseaudio? (
		>=media-libs/gstreamer-0.10.1.2
		>=media-libs/gst-plugins-base-0.10.1.2 )
	smartcard? ( >=dev-libs/nss-3.11.2 )"
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
		$(use_enable policykit polkit)
		$(use_enable pulseaudio pulse)
		$(use_enable !pulseaudio gstreamer)
		$(use_enable smartcard smartcard-support)"

	if use pulseaudio; then
		elog "Building volume media keys using Pulseaudio"
	else
		elog "Building volume media keys using GStreamer"
	fi
}

src_prepare() {
	gnome2_src_prepare

	epatch "${DISTDIR}/${PN}-2.30.0-gst-vol-control-support.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

src_install() {
	gnome2_src_install

	echo 'GSETTINGS_BACKEND="dconf"' >> 51gsettings-dconf
	doenvd 51gsettings-dconf || die "doenvd failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! use pulseaudio; then
		elog "GStreamer volume control support is a feature powered by Gentoo GNOME Team"
		elog "PLEASE DO NOT report bugs upstream, report on https://bugs.gentoo.org instead"
	fi
}
