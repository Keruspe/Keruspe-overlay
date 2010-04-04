# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit base

DESCRIPTION="A map-rendering application and a library for OpenStreetMap"
HOMEPAGE="http://trac.openstreetmap.ch/trac/memphis"
SRC_URI="http://wenner.ch/files/public/mirror/${PN}/${P}.tar.gz"

LICENSE="LGPL"
SLOT="0.2"
KEYWORDS="~amd64 ~x86"
IUSE="introspection"

DEPEND=">=dev-libs/expat-2.0.1
	introspection? ( dev-libs/gobject-introspection )
	>=x11-libs/cairo-1.8.8
	>=dev-libs/glib-2.3.4"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable introspection)
}
