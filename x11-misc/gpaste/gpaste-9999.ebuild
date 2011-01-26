# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit autotools gnome2 git

DESCRIPTION="Clipboard management system"
HOMEPAGE="http://github.com/Keruspe/GPaste"
SRC_URI=""
EGIT_REPO_URI="http://github.com/Keruspe/GPaste.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/glib:2
	>=sys-devel/gettext-0.18
	dev-util/intltool
	x11-libs/gtk+:3
	dev-lang/vala:0.12"
RDEPEND="${DEPEND}"

WANT_AUTOMAKE="1.11"

src_prepare() {
	mkdir m4
	eautoreconf
	intltoolize --force --automake
	gnome2_src_prepare
}
