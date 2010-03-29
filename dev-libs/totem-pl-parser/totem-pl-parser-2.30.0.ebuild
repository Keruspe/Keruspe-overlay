# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2

DESCRIPTION="Playlist parsing library"
HOMEPAGE="http://www.gnome.org/projects/totem/"
LICENSE="LGPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="doc introspection test"

RDEPEND=">=dev-libs/glib-2.21.6
	>=x11-libs/gtk+-2.12
	dev-libs/gmime:2.4"
DEPEND="${RDEPEND}
	!<media-video/totem-2.21
	>=dev-util/intltool-0.35
	dev-util/gtk-doc-am
	introspection? ( dev-libs/gobject-introspection )
	doc? ( >=dev-util/gtk-doc-1.11 )"

DOCS="AUTHORS ChangeLog NEWS"
G2CONF="${G2CONF} $(use_enable introspection) --disable-static"

src_prepare() {
	gnome2_src_prepare

	if use doc; then
		sed "/^TARGET_DIR/i \GTKDOC_REBASE=/usr/bin/gtkdoc-rebase" \
			-i gtk-doc.make || die "sed 1 failed"
	else
		sed "/^TARGET_DIR/i \GTKDOC_REBASE=$(type -P true)" \
			-i gtk-doc.make || die "sed 2 failed"
	fi
}
