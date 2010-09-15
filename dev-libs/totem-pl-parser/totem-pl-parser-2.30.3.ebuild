# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils gnome2

DESCRIPTION="Playlist parsing library"
HOMEPAGE="http://www.gnome.org/projects/totem/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc introspection test"

RDEPEND=">=dev-libs/glib-2.24
	dev-libs/gmime:2.4
	>=net-libs/libsoup-2.30:2.4[gnome]"
DEPEND="${RDEPEND}
	!<media-video/totem-2.21
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.11
	doc? ( >=dev-util/gtk-doc-1.11 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.14 )"

DOCS="AUTHORS ChangeLog NEWS"

pkg_setup() {
	G2CONF="${G2CONF} --disable-static $(use_enable introspection)"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check || die "emake check failed"
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/libtotem-plparser-mini.so.12
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/libtotem-plparser-mini.so.12
}
