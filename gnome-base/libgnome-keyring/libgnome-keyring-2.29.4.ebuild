# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools gnome2

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug test"

RDEPEND=">=dev-libs/glib-2.16
	>=x11-libs/gtk+-2.18
	gnome-base/gconf
	>=sys-apps/dbus-1.0
	>=dev-libs/libgcrypt-1.2.2
	>=dev-libs/libtasn1-1"
DEPEND="${RDEPEND}
	>=gnome-base/gnome-keyring-2.29.90
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9"

src_prepare() {
	gnome2_src_prepare
	epatch ${FILESDIR}/fix-buggy-from-trunk.patch
}

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable test tests)"
}
