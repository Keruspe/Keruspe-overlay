# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit gnome2

DESCRIPTION="Minimalistic vte-based terminal emulator"
HOMEPAGE="http://github.com/Keruspe/Germinal"
SRC_URI="https://github.com/downloads/Keruspe/${PN/g/G}/${P}.tar.xz"
RESTRICT="nomirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/glib-2.28:2
	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.40
	>=x11-libs/gtk+-3.0.0:3
	x11-libs/vte:2.90"
RDEPEND="${DEPEND}
	app-misc/tmux"

G2CONF="
	--disable-schemas-compile"

DOCS="AUTHORS NEWS ChangeLog README"

