# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit clutter

DESCRIPTION="Clutter is a library for creating graphical user interfaces"

SLOT="1.0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc +gtk +introspection"

RDEPEND=">=dev-libs/glib-2.26
	>=x11-libs/cairo-1.10
	>=x11-libs/pango-1.20[introspection?]
	>=dev-libs/json-glib-0.12[introspection?]
	>=dev-libs/atk-1.7

	virtual/opengl
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXdamage
	x11-libs/libXi
	x11-proto/inputproto
	>=x11-libs/libXfixes-3
	>=x11-libs/libXcomposite-0.4

	gtk? ( || (
		x11-libs/gdk-pixbuf
		>=x11-libs/gtk+-2.0 ) )
	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig
	>=dev-util/gtk-doc-am-1.13
	doc? (
		>=dev-util/gtk-doc-1.13
		>=app-text/docbook-sgml-utils-0.6.14[jadetex]
		dev-libs/libxslt )
"
DOCS="AUTHORS README NEWS ChangeLog*"

src_prepare() {
	sed -e 's/^\(SUBDIRS =\).*/\1/g' \
		-i tests/Makefile.am || die "am tests sed failed"
	sed -e 's/^\(SUBDIRS =\).*/\1/g' \
		-i tests/Makefile.in || die "in tests sed failed"
}

src_configure() {
	local myconf="
		--enable-debug=minimum
		--enable-cogl-debug=minimum
		--enable-conformance=no
		--disable-gcov
		--enable-profile=no
		--enable-maintainer-flags=no
		--enable-xinput
		--with-flavour=glx
		--with-imagebackend=gdk-pixbuf
		$(use_enable introspection)
		$(use_enable doc docs)
		$(use_enable doc cogl2-reference)"

	if ! use gtk; then
		myconf="${myconf} --with-imagebackend=internal"
		ewarn "You have selected the experimental internal image backend"
	fi

	if use debug; then
		myconf="${myconf}
			--enable-debug=yes
			--enable-cogl-debug=yes"
	fi

	econf ${myconf}
}
