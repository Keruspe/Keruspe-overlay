# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit gnome2-live

DESCRIPTION="GNOME Online Accounts"
HOMEPAGE="http://git.gnome.org/browse/gnome-online-accounts/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="facebook +google +introspection twitter yahoo"

DEPEND="
	>=dev-util/gtk-doc-1.3
	>=dev-libs/glib-2.29.5
	x11-libs/gtk+:3
	net-libs/webkit-gtk:3
	dev-libs/json-glib
	gnome-base/gnome-keyring
	>=x11-libs/libnotify-0.7.3
	>=net-libs/rest-0.7
	introspection? ( dev-libs/gobject-introspection )
	dev-util/intltool
	sys-devel/gettext"
RDEPEND="${DEPEND}"

pkg_setup() {
	G2CONF="
		$(use_enable facebook)
		$(use_enable google)
		$(use_enable introspection)
		$(use_enable twitter)
		$(use_enable yahoo)"
}
