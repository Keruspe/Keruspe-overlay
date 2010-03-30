# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils gnome2

DESCRIPTION="An HTTP library implementation in C"
HOMEPAGE="http://www.gnome.org/"
LICENSE="LGPL-2"

SLOT="2.4"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc gnome ssl"

RDEPEND=">=dev-libs/glib-2.21.3
	>=dev-libs/libxml2-2
	ssl? ( >=net-libs/gnutls-2.1.7 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1 )"
PDEPEND="gnome? ( ~net-libs/${PN}-gnome-${PV} )"

DOCS="AUTHORS NEWS README"

G2CONF="${G2CONF}
	--disable-static
	--without-gnome
	$(use_enable ssl)"

src_prepare() {
	gnome2_src_prepare

	sed -e 's/\(test.*\)==/\1=/g' -i configure.ac configure || die "sed failed"

	if use doc; then
		epatch "${FILESDIR}/${PN}-fix-build-without-gnome-with-doc.patch"
	fi
	eautoreconf
}
