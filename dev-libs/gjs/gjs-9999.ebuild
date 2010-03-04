# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools gnome2 git

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="http://live.gnome.org/Gjs"
EGIT_REPO_URI="git://git.gnome.org/gjs"
SRC_URI=""

LICENSE="MIT MPL-1.1 LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="coverage"

RDEPEND=">=dev-libs/glib-2.16.0
	>=dev-libs/gobject-introspection-0.6.3
	dev-libs/dbus-glib
	net-libs/xulrunner:1.9"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	coverage? (
		sys-devel/gcc
		dev-util/lcov )"
DOCS="NEWS README"

S=${WORKDIR}/trunk

src_unpack() {
	git_src_unpack
	cd ${S}
	eautoreconf
}
