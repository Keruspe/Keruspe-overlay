# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit autotools games git-2

DESCRIPTION="A bomberman clone, student project"
HOMEPAGE="http://github.com/Keruspe/Bomb-her-man"
SRC_URI=""
EGIT_REPO_URI="git://github.com/Keruspe/Bomb-her-man.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc nls"

DEPEND="media-libs/sdl-ttf
	x11-libs/cairo
	nls? ( sys-devel/gettext )
	gnome-base/librsvg"
RDEPEND="${DEPEND}
	media-fonts/libertine-ttf"

WANT_AUTOMAKE="1.11"

src_prepare() {
	eautopoint
	eautoreconf
}

src_configure() {
	egamesconf $(use_enable nls) $(use_enable debug)
}

src_install() {
	base_src_install
	rm -f ${ED}${GAMES_DATADIR}/${PN}/biolinum.ttf
	dosym /usr/share/fonts/libertine-ttf/LinBiolinum_R.ttf ${GAMES_DATADIR}/${PN}/biolinum.ttf
}
