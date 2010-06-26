# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils gnome2

DESCRIPTION="Gnome Configuration System and Daemon"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="introspection"

RDEPEND=">=dev-libs/glib-2.23.10
	x11-libs/gtk+:2
	dev-libs/dbus-glib
	sys-apps/dbus
	dev-libs/libgee
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
	>=dev-libs/libxml2-2"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README TODO"

G2CONF="${G2CONF} $(use_enable introspection)"
