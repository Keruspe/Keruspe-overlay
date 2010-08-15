# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils gnome2

MY_PN=${PN/-gnome}
MY_P=${MY_PN}-${PV}

DESCRIPTION="GNOME plugin for libsoup"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${SRC_URI//-gnome}"

LICENSE="LGPL-2"
SLOT="2.4"
KEYWORDS="~amd64 ~x86"
IUSE="debug introspection"

RDEPEND="~net-libs/libsoup-${PV}
	gnome-base/gnome-keyring
	net-libs/libproxy
	>=gnome-base/gconf-2
	dev-db/sqlite:3"
DEPEND="${RDEPEND}
	introspection? ( dev-libs/gobject-introspection )
	>=dev-util/pkgconfig-0.9
	dev-util/gtk-doc-am"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable introspection)
		--disable-static
		--with-libsoup-system
		--with-gnome"
}
src_prepare() {
	gnome2_src_prepare
	sed -e 's/\(test.*\)==/\1=/g' -i configure.ac configure || die "sed failed"
	epatch "${FILESDIR}"/${P}-system-lib.patch
	rm -f libsoup/*.gir
	sed -i 's/tests//' Makefile.am
	eautoreconf
}

src_install() {
	gnome2_src_install
	rm -f ${D}/usr/lib*/pkgconfig/libsoup-2.4.pc
	rm -rf ${D}/usr/share/gtk-doc
}
