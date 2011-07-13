# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
WANT_AUTOMAKE="1.11"

inherit clutter gnome2-live
DESCRIPTION="A hardware accelerated 3D graphics API"

SLOT="1.0"
IUSE="debug +introspection"
KEYWORDS=""

RDEPEND="
	>=dev-libs/glib-2.26:2
	>=x11-libs/cairo-1.20
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
	sys-devel/gettext
	dev-util/pkgconfig
	>=dev-util/gtk-doc-am-1.13"
DOCS="README NEWS ChangeLog*"

src_prepare() {
	# Some gettext stuff, we can't run gettextize because that does too much
	cp "${ROOT}/usr/share/gettext/po/Makefile.in.in" "${S}/po"

	gnome2_src_prepare

	G2CONF="
		--enable-debug=no
		--enable-profile=no
		--enable-maintainer-flags=no
		--enable-glx=yes
		--enable-gdk-pixbuf=yes
		$(use_enable introspection)"

	if use debug; then
		G2CONF="${myconf}
			--enable-debug=yes"
	fi
}
