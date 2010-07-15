# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils gnome2

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lzma"

RDEPEND="
	>=x11-libs/gtk+-2.90:3
	>=dev-libs/glib-2.25.10
	>=dev-libs/libxml2-2.6.5
	>=dev-libs/libxslt-1.1.4
	>=dev-libs/dbus-glib-0.71
	>=gnome-extra/yelp-xsl-2.31.3
	>=net-libs/webkit-gtk-1.3.3[gtk3]
	app-arch/bzip2
	lzma? ( >=app-arch/xz-utils-4.9 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.41
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable lzma)"
}
