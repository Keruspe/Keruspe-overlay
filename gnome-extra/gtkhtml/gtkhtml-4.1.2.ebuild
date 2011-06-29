# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
inherit gnome2 eutils

DESCRIPTION="Lightweight HTML Rendering/Printing/Editing Engine"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="4.0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-3.0:3
	>=x11-libs/cairo-1.10
	>=x11-themes/gnome-icon-theme-2.22.0
	>=gnome-base/orbit-2
	>=app-text/enchant-1.1.7
	gnome-base/gconf:2
	>=app-text/iso-codes-0.49
	>=net-libs/libsoup-2.26.0:2.4"
DEPEND="${RDEPEND}
	x11-proto/xproto
	sys-devel/gettext
	>=dev-util/intltool-0.40.0
	>=dev-util/pkgconfig-0.9"

pkg_setup() {
	ELTCONF="--reverse-deps"
	G2CONF="${G2CONF}
		--disable-static
		--disable-deprecated-warning-flags"
	DOCS="AUTHORS BUGS ChangeLog NEWS README TODO"
}

src_install() {
	gnome2_src_install

	elog "The gtkhtml-editor-test utility is now called gtkhtml-editor-test-${SLOT}"
	# Don't collide with 3.14 slot
	mv "${ED}"/usr/bin/gtkhtml-editor-test{,-${SLOT}} || die
}
