# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GNOME2_LA_PUNT="yes"

inherit gnome2-live

DESCRIPTION="GNOME framework for accessing online accounts"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
IUSE="doc +introspection"
KEYWORDS=""

RDEPEND="
	>=dev-libs/glib-2.29.5:2
	dev-libs/json-glib[introspection?]
	gnome-base/libgnome-keyring
	net-libs/rest:0.7[introspection?]
	net-libs/webkit-gtk:3[introspection?]
	>=x11-libs/gtk+-3.0.0:3[introspection?]
	>=x11-libs/libnotify-0.7

	introspection? ( >=dev-libs/gobject-introspection-0.6.2 )"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-util/intltool
	sys-devel/gettext

	doc? ( >=dev-util/gtk-doc-1.3 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static"
	DOCS="NEWS" # README is empty
}
