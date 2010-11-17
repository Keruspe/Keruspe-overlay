# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2

DESCRIPTION="Collection of GSettings schemas for GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.21"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40"

DOCS="AUTHORS ChangeLog HACKING NEWS README"
