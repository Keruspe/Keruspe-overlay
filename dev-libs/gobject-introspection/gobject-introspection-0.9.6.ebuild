# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND=2:2.5
inherit autotools gnome2 python

DESCRIPTION="Introspection infrastructure for gobject library bindings"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-libs/glib-2.19.0
	virtual/libffi"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-1.12
	dev-util/pkgconfig
	sys-devel/flex
	test? ( x11-libs/cairo )
	!<dev-lang/vala-0.10.0"

G2CONF="${G2CONF} --disable-static"

src_prepare() {
	gnome2_src_prepare
	use doc && MAKEOPTS="-j1"
	ln -sf $(type -P true) py-compile
	sed -i 's/tests//' Makefile.am #sandbox violation
	gtkdocize
	eautoreconf
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/${PN}/giscanner
	python_need_rebuild
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/${PN}/giscanner
}
