# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils cmake-utils
DESCRIPTION="sakura is a terminal emulator based on GTK and VTE"
HOMEPAGE="http://www.pleyades.net/david/sakura.php"
SRC_URI="http://www.pleyades.net/david/projects/sakura/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.14
	>=x11-libs/gtk+-2.10
	>=x11-libs/vte-0.16.15"

DEPEND="${RDEPEND}
	>=dev-lang/perl-5.10.1
	>=dev-util/cmake-2.4.7"

DOCS="AUTHORS INSTALL"

src_prepare() {
	epatch ${FILESDIR}/graph.patch
	cmake_src-prepare
}
