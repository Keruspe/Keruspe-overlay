# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools git gnome2

DESCRIPTION="GTK+3 standard engines and themes"
HOMEPAGE="http://www.gtk.org/"

SRC_URI=""
EGIT_REPO_URI="git://git.gnome.org/gtk-theme-engine-clearlooks"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-util/intltool"
DEPEND="${RDEPEND}"

G2CONF="--enable-animation"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	gnome2_src_prepare
	intltoolize
	eautoreconf
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete
}
