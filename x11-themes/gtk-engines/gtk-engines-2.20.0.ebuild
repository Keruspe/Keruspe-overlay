# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2

DESCRIPTION="GTK+2 standard engines and themes"
HOMEPAGE="http://www.gtk.org/"
LICENSE="LGPL-2.1"

SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="accessibility lua"

RDEPEND=">=x11-libs/gtk+-2.12
	lua? ( dev-lang/lua )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.31
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README"

G2CONF="${G2CONF} --enable-animation $(use_enable lua) $(use_with lua system-lua)"
use accessibility || G2CONF="${G2CONF} --disable-hc"
