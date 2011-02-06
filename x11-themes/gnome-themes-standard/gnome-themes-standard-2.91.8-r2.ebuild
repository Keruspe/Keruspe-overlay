# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
GCONF_DEBUG="no"
inherit gnome2

DESCRIPTION="Adwaita theme for GNOME Shell"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.91.6:3
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.7
	>=dev-util/pkgconfig-0.19
	>=dev-util/intltool-0.40
	sys-devel/gettext"
# This ebuild does not install any binaries
RESTRICT="binchecks strip"
G2CONF="--disable-static"
DOCS="ChangeLog NEWS"

src_prepare() {
	# Install cursors in the right place
	sed -e 's:^\(cursordir.*\)icons\(.*\):\1cursors/xorg-x11\2:' \
		-i themes/Adwaita/cursors/Makefile.am \
		-i themes/Adwaita/cursors/Makefile.in || die
}

src_install() {
	gnome2_src_install

	# Make it the default cursor theme
	cd "${ED}/usr/share/cursors/xorg-x11" || die
	ln -sfn Adwaita default || die
}
