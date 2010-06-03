# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools clutter

DESCRIPTION="Clutter is a library for creating graphical user interfaces"

SLOT="1.0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc +gtk introspection +opengl"

WANT_AUTOMAKE=1.11

RDEPEND=">=dev-libs/glib-2.16
	>=x11-libs/cairo-1.4
	>=x11-libs/pango-1.20

	gtk? ( >=x11-libs/gtk+-2.0 )
	opengl? (
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXdamage
		x11-libs/libXi
		x11-proto/inputproto

		>=x11-libs/libXfixes-3
		>=x11-libs/libXcomposite-0.4 )
	!opengl? ( media-libs/libsdl )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/gtk-doc-am
	doc? (
		>=dev-util/gtk-doc-1.11
		>=app-text/docbook-sgml-utils-0.6.14[jadetex]
		app-text/xmlto )
	introspection? (
		>=dev-libs/gobject-introspection-0.6.4
		>=x11-libs/pango-1.28.0[introspection] )"

src_configure() {
	local myconf=""

	if use opengl; then
		elog "Using GLX for OpenGL backend"
		myconf="${myconf} --with-flavour=glx"
	else
		elog "Using SDL for OpenGL backend"
		myconf="${myconf} --with-flavour=sdl"
		ewarn "You have disabled OpenGL, do not report bugs about breakage"
	fi

	if use gtk; then
		myconf="${myconf} --with-imagebackend=gdk-pixbuf"
	else
		myconf="${myconf} --with-imagebackend=internal"
		ewarn "You have selected the experimental internal image backend"
	fi

	if ! use debug; then
		myconf="${myconf}
			--enable-debug=minimum
			--enable-cogl-debug=minimum"
	fi

	myconf="${myconf}
		--enable-maintainer-flags=no
		--enable-xinput
		--with-json=internal
		$(use_enable introspection)"
	econf ${myconf}
}

src_prepare() {
	epatch ${FILESDIR}/clutter-group-atk-include.patch
	eautoreconf
}
