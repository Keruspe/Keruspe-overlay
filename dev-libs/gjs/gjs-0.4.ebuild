# Copyright 1999-2010 Gentoo Foundation
# Copyright 2009-2010 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="http://live.gnome.org/Gjs"

LICENSE="MIT MPL-1.1 LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="coverage"

RDEPEND=">=dev-libs/glib-2.16.0
	>=dev-libs/gobject-introspection-0.6.3

	dev-libs/dbus-glib
	net-libs/xulrunner:1.9"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	coverage? (
		sys-devel/gcc
		dev-util/lcov )"
DOCS="NEWS README"

src_prepare() {
	epatch ${FILESDIR}/${P}-xulrunner-1.9.2.patch
}
