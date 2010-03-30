# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2

DESCRIPTION="Flash player and thumbnailer for GNOME"
HOMEPAGE="http://swfdec.freedesktop.org/wiki/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.12.0
		gnome-base/gconf
		>=media-libs/swfdec-0.8[gtk]"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0
	sys-devel/gettext"

DOCS="NEWS README"

src_prepare() {
	gnome2_src_prepare

	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in || die "sed failed"
}
