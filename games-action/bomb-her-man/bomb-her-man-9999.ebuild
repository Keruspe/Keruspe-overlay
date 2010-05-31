# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games git

DESCRIPTION="A bomberman clone, student project for SUPINFO, France"
HOMEPAGE="http://github.com/Keruspe/Bomb-her-man"
SRC_URI=""
EGIT_REPO_URI="git://github.com/Keruspe/Bomb-her-man.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="media-libs/sdl-ttf
	x11-libs/cairo
	gnome-base/librsvg
	doc? ( app-doc/doxygen )"
RDEPEND="${DEPEND}"

src_compile() {
	emake ROOTDIR=/
	use doc && emake doc
}

src_install() {
	emake DESTDIR=${D} install
	use doc && emake DESTDIR=${D} install-doc
}
