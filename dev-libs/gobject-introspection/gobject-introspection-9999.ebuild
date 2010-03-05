# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND=2:2.6
inherit autotools gnome2 git python

DESCRIPTION="Introspection infrastructure for gobject library bindings"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"
EGIT_REPO_URI="git://git.gnome.org/gobject-introspection"
SRC_URI=""

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-libs/glib-2.19.0
	>=dev-lang/python-2.5
	virtual/libffi"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-1.12
	dev-util/pkgconfig
	sys-devel/flex"

src_prepare() {
	G2CONF="${G2CONF} --disable-static"
	use doc && MAKEOPTS="-j1"
	ln -sf $(type -P true) py-compile
}

src_unpack() {
	git_src_unpack	
	cd ${S}
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
