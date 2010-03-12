# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils gnome2 clutter

DESCRIPTION="Clutter-GTK - GTK+ Integration library for Clutter"
SLOT="1.0"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug examples introspection"

RDEPEND="
	>=x11-libs/gtk+-2.17.9
	>=media-libs/clutter-1.2[opengl]"
DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.11 )
	introspection? (
		media-libs/clutter[introspection]
		>=dev-libs/gobject-introspection-0.6.3
		>=dev-libs/gir-repository-0.6.3[gtk] )"
EXAMPLES="examples/{*.c,redhand.png}"

G2CONF="${G2CONF}
	--with-flavour=x11
	--enable-maintainer-flags=no
	$(use_enable introspection)"

src_prepare() {
	epatch ${FILESDIR}/fix-deprecated-symbols.patch
	gnome2_src_prepare
}
