# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools gnome2

DESCRIPTION="Library to access RESTful web-services"
HOMEPAGE="http://moblin.org/projects/librest"
SRC_URI="http://ftp.de.debian.org/debian/pool/main/libr/librest/${PN}_${PV}.orig.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

RDEPEND=">=dev-libs/glib-2.18.0
	>=net-libs/libsoup-2.4
	gnome? ( >=net-libs/libsoup-gnome-2.25.1 )
	>=dev-libs/libxml2-2"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_with gnome)"
}

src_prepare() {
	gnome2_src_prepare
	gtkdocize
	eautoreconf
}
