# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.5"

inherit autotools git gnome2 python

DESCRIPTION="Introspection infrastructure for gobject library bindings"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

SRC_URI=""
EGIT_REPO_URI="git://git.gnome.org/gobject-introspection"

RDEPEND=">=dev-libs/glib-2.24:2
	virtual/libffi"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/flex
	doc? ( >=dev-util/gtk-doc-1.12 )
	test? ( x11-libs/cairo )
	dev-util/gtk-doc"

pkg_setup() {
	DOCS="AUTHORS CONTRIBUTORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable test tests)"

	python_set_active_version 2
}

src_unpack() {
	git_src_unpack
}

src_prepare() {
	use doc && MAKEOPTS="-j1"
	ln -sf $(type -P true) py-compile
	gtkdocize
	eautoreconf
}

src_install() {
	gnome2_src_install
	python_convert_shebangs 2 "${ED}"usr/bin/g-ir-scanner
	python_convert_shebangs 2 "${ED}"usr/bin/g-ir-annotation-tool
	find "${ED}" -name "*.la" -delete || die "la files removal failed"
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/${PN}/giscanner
	python_need_rebuild
}

pkg_postrm() {
	python_mod_cleanup /usr/lib*/${PN}/giscanner
}
