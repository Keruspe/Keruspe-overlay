# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools git gnome2

DESCRIPTION="Clutter based world map renderer"
HOMEPAGE="http://blog.pierlux.com/projects/libchamplain/en/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gtk introspection"

SRC_URI=""
EGIT_REPO_URI="git://git.gnome.org/libchamplain"

RDEPEND=">=dev-libs/glib-2.16
	>=x11-libs/cairo-1.4
	>=net-libs/libsoup-2.26[gnome]

	media-libs/clutter:1.0
	dev-db/sqlite:3

	gtk? (
		>=x11-libs/gtk+-2.18
		media-libs/memphis:0.2
		>=media-libs/clutter-gtk-0.10:1.0 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.9 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.3 )"

G2CONF="${G2CONF}
	--disable-static
	$(use_enable introspection)
	$(use_enable gtk)"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	gnome2_src_prepare
	epatch ${FILESDIR}/fix-includes.patch
	gtkdocize --copy
	eautoreconf
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}
