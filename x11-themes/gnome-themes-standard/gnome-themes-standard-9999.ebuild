# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools git gnome2

DESCRIPTION="Standard Themes for GNOME Applications"
HOMEPAGE="http://git.gnome.org/browse/gnome-themes-standard/"
SRC_URI=""
EGIT_REPO_URI="git://git.gnome.org/gnome-themes-standard"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	gnome2_src_prepare
	eautoreconf
}
