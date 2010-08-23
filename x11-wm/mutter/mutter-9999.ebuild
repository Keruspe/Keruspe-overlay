# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools gnome2 git

DESCRIPTION="Upcoming GNOME 3 window manager (derived from metacity)"
HOMEPAGE="http://blogs.gnome.org/metacity/"
EGIT_REPO_URI="git://git.gnome.org/mutter"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug introspection +sound test xinerama"

RDEPEND=">=x11-libs/gtk+-2.90.5:3[introspection?]
	>=x11-libs/pango-1.28[X,introspection?]
	>=gnome-base/gconf-2
	>=dev-libs/glib-2.14
	>=x11-libs/startup-notification-0.7
	>=x11-libs/libXcomposite-0.2

	>=media-libs/clutter-1.2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender
	>=x11-libs/cairo-1.9.12

	sound? ( >=media-libs/libcanberra-0.25-r1[gtk3] )
	introspection? ( dev-libs/gobject-introspection )
	xinerama? ( x11-libs/libXinerama )
	gnome-extra/zenity
	!x11-misc/expocity"
DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.8
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	test? ( app-text/docbook-xml-dtd:4.5 )
	xinerama? ( x11-proto/xineramaproto )
	x11-proto/xextproto
	x11-proto/xproto"

DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README *.txt doc/*.txt"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-gconf
		--enable-shape
		--enable-sm
		--enable-startup-notification
		--enable-xsync
		--enable-verbose-mode
		--enable-compile-warnings
		--with-gtk=3.0
		$(use_with sound libcanberra)
		$(use_with introspection)
		$(use_enable xinerama)"
}

src_prepare() {
	gnome2_src_prepare
	intltoolize --force --copy --automake || die
	eautoreconf
}
