# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit gnome2-live

DESCRIPTION="Contacts manager for gnome"
HOMEPAGE="https://live.gnome.org/Design/Apps/Contacts"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/vala:0.14
	dev-util/intltool
	sys-devel/gettext
	dev-libs/glib
	x11-libs/gtk+:3[introspection]
	>=gnome-base/gnome-desktop-3[introspection]
	>=dev-libs/folks-0.6.1[vala]
	x11-libs/libnotify[introspection]"
RDEPEND="${DEPEND}"

src_compile() {
	emake VALAC=$(type -p valac-0.14)
}

