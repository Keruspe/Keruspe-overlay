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
IUSE="debug doc"

RDEPEND="~net-libs/libsoup-${PV}
	gnome-base/gnome-keyring
	net-libs/libproxy
	>=gnome-base/gconf-2
	dev-db/sqlite:3"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1 )"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS NEWS README"

G2CONF="${G2CONF}
	--disable-static
	--with-libsoup-system
	--with-gnome"

src_prepare() {
	gnome2_src_prepare

	sed -e 's/\(test.*\)==/\1=/g' -i configure.ac configure || die "sed failed"

	epatch "${FILESDIR}"/${PN}-system-lib.patch
	eautoreconf
}
