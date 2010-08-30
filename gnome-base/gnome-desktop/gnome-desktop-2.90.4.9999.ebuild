# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2 autotools eutils

DESCRIPTION="Libraries for the gnome desktop that are not part of the UI"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

SRC_URI="http://www.imagination-land.com/${P}.tar.bz2"
RESTRICT="nomirror"

RDEPEND=">=x11-libs/gtk+-2.90.2:3
	>=dev-libs/glib-2.19.1
	>=x11-libs/libXrandr-1.2
	>=gnome-base/gconf-2
	>=x11-libs/startup-notification-0.5
	x11-libs/libX11"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9
	>=app-text/gnome-doc-utils-0.3.2
	doc? ( >=dev-util/gtk-doc-1.4 )
	~app-text/docbook-xml-dtd-4.1.2
	x11-proto/xproto
	>=x11-proto/randrproto-1.2"
PDEPEND=">=gnome-base/gnome-desktop-2.31:0"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--with-gnome-distributor=Gentoo
		--disable-scrollkeeper
		--disable-static
		--with-pnp-ids-path=/usr/share/libgnome-desktop/pnp.ids"
}