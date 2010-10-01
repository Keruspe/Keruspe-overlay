# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2

DESCRIPTION="Library for managing folks"
HOMEPAGE="http://telepathy.freedesktop.org/wiki/Folks"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=net-libs/telepathy-glib-0.11.11[vala]
	>=dev-lang/vala-0.9.4
	>=dev-libs/glib-2.24"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.21"

MAKEOPTS=-j1

src_prepare() {
	gnome2_src_prepare
	sed -i 's/tests//g' Makefile.in
}

pkg_setup() {
	G2CONF="--disable-maintainer-mode
			--disable-static"
}
