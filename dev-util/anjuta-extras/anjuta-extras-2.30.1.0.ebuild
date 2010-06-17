# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome.org base 

DESCRIPTION="Extra plugins for Anjuta"
HOMEPAGE="http://www.anjuta.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="scintilla valgrind"

RDEPEND=">=dev-util/anjuta-${PV}
	valgrind? ( dev-util/valgrind )
	"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog FUTURE MAINTAINERS NEWS README ROADMAP THANKS TODO"

src_configure() {
	econf $(use_enable scintilla plugin-scintilla) \
		$(use_enable valgrind plugin-valgrind)
}
