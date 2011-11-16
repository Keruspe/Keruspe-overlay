# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

WANT_AUTOMAKE=1.11

inherit autotools base

DESCRIPTION="A map-rendering application and a library for OpenStreetMap"
HOMEPAGE="http://trac.openstreetmap.ch/trac/memphis/"
SRC_URI="http://wenner.ch/files/public/mirror/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0.2"
KEYWORDS="amd64 x86"
IUSE="debug doc +introspection vala"

RDEPEND="
	>=dev-libs/expat-2.0.1
	dev-libs/glib:2
	>=x11-libs/cairo-1.8.8
	introspection? ( dev-libs/gobject-introspection )
	vala? ( dev-lang/vala:0.14 )"
DEPEND="${RDEPEND}
		doc? ( >=dev-util/gtk-doc-1.12 )"

DOCS=(AUTHORS ChangeLog NEWS README)

src_configure() {
	CFLAGS="${CFLAGS}" \
	econf \
		VALAC=$(type -p valac-0.14) \
		$(use_enable debug) \
		$(use_enable doc gtk-doc) \
		$(use_enable introspection) \
		$(use_enable vala)
}
