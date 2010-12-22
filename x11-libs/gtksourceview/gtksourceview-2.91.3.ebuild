# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2 virtualx

DESCRIPTION="A text widget implementing syntax highlighting and other features"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="3.0"
KEYWORDS="~amd64 ~x86"
IUSE="doc glade +introspection"

RDEPEND=">=x11-libs/gtk+-2.91.3:3[introspection?]
	>=dev-libs/libxml2-2.6
	>=dev-libs/glib-2.14
	glade? ( >=dev-util/glade-3.2 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README"

pkg_config() {
	G2CONF="${G2CONF}
		$(use_enable glade glade-catalog)
		$(use_enable introspection)"
}

src_prepare() {
	sed -i -e 's:--warn-all::' gtksourceview/Makefile.in
	sed -i 's:2.91.4:2.91.3:' configure
	gnome2_src_prepare
}

src_test() {
	Xemake check || die "Test phase failed"
}

src_install() {
	gnome2_src_install
	insinto /usr/share/${PN}-3.0/language-specs
	doins "${FILESDIR}"/2.0/gentoo.lang || die "doins failed"
}
