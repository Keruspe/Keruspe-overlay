# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools gnome2

DESCRIPTION="Utilities for the Gnome2 desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="applet doc ipv6 test"

RDEPEND=">=dev-libs/glib-2.20.0
	>=x11-libs/gtk+-2.18.0
	applet? ( >=gnome-base/gnome-panel-2.28 )
	>=gnome-base/libgtop-2.12
	>=gnome-base/gconf-2
	>=media-libs/libcanberra-0.4[gtk]
	x11-libs/libXext"

DEPEND="${RDEPEND}
	x11-proto/xextproto
	app-text/gnome-doc-utils
	app-text/scrollkeeper
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.10 )"

DOCS="AUTHORS ChangeLog NEWS README THANKS"

G2CONF="${G2CONF}
	$(use_enable ipv6)
	$(use_enable applet gdict-applet)
	--enable-maintainer-flags=no
	--enable-zlib
	--disable-static
	--disable-schemas-install
	--disable-scrollkeeper"

if ! use debug; then
	G2CONF="${G2CONF} --enable-debug=minimum"
fi

src_prepare() {
	gnome2_src_prepare

	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in || die "sed failed"

	if ! use test ; then
		sed -e 's/ tests//' -i logview/Makefile.{am,in} || die "sed failed";
	fi
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}
