# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils gnome2

DESCRIPTION="Fork of bluez-gnome focused on integration with GNOME"
HOMEPAGE="http://live.gnome.org/GnomeBluetooth"

LICENSE="GPL-2 LGPL-2.1"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="doc +introspection nautilus"

COMMON_DEPEND=">=dev-libs/glib-2.25.7:2
	!net-wireless/gnome-bluetooth:2
	>=x11-libs/gtk+-2.91.3:3
	>=x11-libs/libnotify-0.7.0
	>=dev-libs/dbus-glib-0.74
	dev-libs/libunique
	nautilus? ( >=gnome-extra/nautilus-sendto-2.31.7 )"
RDEPEND="${COMMON_DEPEND}
	>=net-wireless/bluez-4.34
	app-mobilephone/obexd"
DEPEND="${COMMON_DEPEND}
	!!net-wireless/bluez-gnome
	app-text/gnome-doc-utils
	app-text/scrollkeeper
	dev-libs/libxml2
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext
	x11-libs/libX11
	x11-libs/libXi
	x11-proto/xproto
	doc? ( >=dev-util/gtk-doc-1.9 )"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable introspection)
		$(use_enable nautilus nautilus-sendto)
		--disable-moblin
		--disable-desktop-update
		--disable-icon-update"
	DOCS="AUTHORS README NEWS ChangeLog"
}

src_prepare() {
	gnome2_src_prepare
	epatch ${FILESDIR}/fix-gtk3.patch
}

src_install() {
	gnome2_src_install
	find "${ED}"/usr/$(get_libdir)/${PN}/plugins -name "*.la" -delete \
		|| die "la file removal failed (1)"
	if use nautilus; then
		find "${ED}"/usr/$(get_libdir)/nautilus-sendto/plugins -name "*.la" -delete \
			|| die "la file removal failed (1)"
	fi
}
