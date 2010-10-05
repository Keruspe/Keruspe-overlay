# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="http://live.gnome.org/Gjs"
MAKEOPTS="-j1"

LICENSE="MIT MPL-1.1 LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="coverage examples"

RDEPEND=">=dev-libs/glib-2.16.0
	>=dev-libs/gobject-introspection-0.9.5
	dev-libs/dbus-glib
	x11-libs/cairo
	net-libs/xulrunner:1.9"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	coverage? (
		sys-devel/gcc
		dev-util/lcov )"
DOCS="NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable coverage)"
}

src_install() {
	gnome2_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins ${S}/examples/* || die "doins examples failed!"
	fi
}
