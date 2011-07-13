# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
WANT_AUTOMAKE="1.11"

inherit clutter gnome2-live
DESCRIPTION="Clutter is a library for creating graphical user interfaces"

SLOT="1.0"
IUSE="debug doc +introspection"
KEYWORDS=""

RDEPEND="
	>=dev-libs/glib-2.26:2
	>=x11-libs/cairo-1.10
	>=x11-libs/pango-1.20[introspection?]
	>=dev-libs/json-glib-0.12[introspection?]
	>=dev-libs/atk-1.17

	x11-libs/gdk-pixbuf:2

	virtual/opengl
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXdamage
	x11-proto/inputproto
	>=x11-libs/libXi-1.3
	>=x11-libs/libXfixes-3
	>=x11-libs/libXcomposite-0.4

	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )"
DEPEND="${RDEPEND}
	>=media-libs/cogl-1.6
	sys-devel/gettext
	dev-util/pkgconfig
	>=dev-util/gtk-doc-am-1.13
	doc? (
		>=dev-util/gtk-doc-1.13
		>=app-text/docbook-sgml-utils-0.6.14[jadetex]
		dev-libs/libxslt )"
DOCS="README NEWS ChangeLog*"

src_prepare() {
	# Some gettext stuff, we can't run gettextize because that does too much
	cp "${ROOT}/usr/share/gettext/po/Makefile.in.in" "${S}/po"

	gnome2_src_prepare

	# XXX: Conformance test suite (and clutter itself) does not work under Xvfb
	# XXX: Profiling, coverage disabled for now
	# XXX: What about eglx/eglnative/opengl-egl-xlib/osx/wayland/etc flavours?
	#      Uses gudev-1.0 and libxkbcommon for eglnative/cex1000
	G2CONF="
		--enable-debug=minimum
		--enable-conformance=no
		--disable-gcov
		--enable-profile=no
		--enable-maintainer-flags=no
		--enable-xinput
		--with-flavour=glx
		$(use_enable introspection)
		$(use_enable doc docs)"

	if use debug; then
		G2CONF="${myconf}
			--enable-debug=yes"
	fi
}
