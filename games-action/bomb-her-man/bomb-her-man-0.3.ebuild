# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools games

DESCRIPTION="A bomberman clone, student project for SUPINFO, France"
HOMEPAGE="http://github.com/Keruspe/Bomb-her-man"
SRC_URI="http://github.com/Keruspe/Bomb-her-man/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc nls"

DEPEND="media-libs/sdl-ttf
	x11-libs/cairo
	nls? ( sys-devel/gettext )
	gnome-base/librsvg"
	#doc? ( app-doc/doxygen )"
RDEPEND="${DEPEND}
	media-fonts/libertine-ttf"

COMMIT=f2a448e
S=${WORKDIR}/Keruspe-${PN/b/B}-${COMMIT}

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
	rm -f ${D}${GAMES_DATADIR}/${PN}/biolinum.ttf
	dosym /usr/share/fonts/libertine-ttf/LinBiolinum_Re-0.6.4.ttf ${GAMES_DATADIR}/${PN}/biolinum.ttf
}
