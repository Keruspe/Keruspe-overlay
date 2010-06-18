# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools base libtool

DESCRIPTION="Telepathy Mission Control"
HOMEPAGE="http://telepathy.freedesktop.org"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=net-libs/telepathy-glib-0.9.02
	>=dev-libs/dbus-glib-0.82
	>=dev-libs/glib-2.22.0
	dev-libs/libxml2
	>=sys-apps/dbus-1.1.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/gtk-doc
	dev-libs/libxslt"

MAKEOPTS="${MAKEOPTS} -j1"

src_configure() {
	econf $(use_enable test coding-style-checks)
}
