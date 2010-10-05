# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2 eutils

DESCRIPTION="GTK+3 standard engines and themes"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2.1"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="accessibility"

RDEPEND=">=x11-libs/gtk+-2.91:3"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.31
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} --enable-animation $(use_enable accessibility hc)"
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete
}
