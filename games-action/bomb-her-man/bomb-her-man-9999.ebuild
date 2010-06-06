# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools games git

DESCRIPTION="A bomberman clone, student project for SUPINFO, France"
HOMEPAGE="http://github.com/Keruspe/Bomb-her-man"
SRC_URI=""
EGIT_REPO_URI="http://github.com/Keruspe/Bomb-her-man.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="media-libs/sdl-ttf
	x11-libs/cairo
	gnome-base/librsvg"
	#doc? ( app-doc/doxygen )"
RDEPEND="${DEPEND}
	media-fonts/libertine-ttf"

src_prepare() {
	eautoreconf
}

src_configure() {
	egamesconf
}

src_install() {
	base_src_install
	rm -f ${D}${GAMES_DATADIR}/${PN}/biolinum.ttf
	dosym /usr/share/fonts/libertine-ttf/Biolinum_Re-0.4.1.ttf ${GAMES_DATADIR}/${PN}/biolinum.ttf
}
