# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools git gnome2

DESCRIPTION="D-Bus interface for user account query and manipulation"
HOMEPAGE="http://cgit.freedesktop.org/accountsservice/"
SRC_URI=""
EGIT_REPO_URI="git://anongit.freedesktop.org/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/glib-2
	dev-libs/dbus-glib
	sys-auth/polkit"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	mkdir m4
	gnome2_src_prepare
	intltoolize --automake --force
	eautoreconf
}

