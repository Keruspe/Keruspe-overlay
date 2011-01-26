# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
GCONF_DEBUG="yes"
inherit gnome2

DESCRIPTION="Utilities for the Gnome2 desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="bonobo doc ipv6 test"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-libs/glib-2.20:2
	>=x11-libs/gtk+-2.91.1:3
	>=gnome-base/gconf-2
	>=gnome-base/gsettings-desktop-schemas-0.1.0
	>=gnome-base/libgtop-2.12
	>=media-libs/libcanberra-0.26-r2[gtk3]
	x11-libs/libXext
	x11-libs/libX11
	bonobo? ( || ( gnome-base/gnome-panel[bonobo] <gnome-base/gnome-panel-2.32 ) )"

DEPEND="${RDEPEND}
	x11-proto/xextproto
	app-text/scrollkeeper
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.10 )"

pkg_setup() {
	if ! use debug; then
		G2CONF="${G2CONF} --enable-debug=minimum"
	fi

	G2CONF="${G2CONF}
		$(use_enable ipv6)
		$(use_enable bonobo gdict-applet)
		--enable-zlib
		--disable-maintainer-flags
		--disable-static
		--disable-schemas-install
		--disable-schemas-compile
		--disable-scrollkeeper"
	DOCS="AUTHORS ChangeLog NEWS README THANKS"
}

src_prepare() {
	gnome2_src_prepare

	find . -iname 'Makefile.am' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die "sed 1 failed"
	find . -iname 'Makefile.in' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die "sed 1 failed"

	if ! use test ; then
		sed -e 's/ tests//' -i logview/Makefile.{am,in} || die "sed 2 failed"
	fi
}

src_install() {
	gnome2_src_install
	find "${ED}" -name "*.la" -delete || die "remove of la files failed"
}
