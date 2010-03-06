# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils gnome2

DESCRIPTION="The Gnome Terminal"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.16.0
	>=x11-libs/gtk+-2.14.0
	>=gnome-base/gconf-2.14
	>=x11-libs/startup-notification-0.8
	>=x11-libs/vte-0.22.0
	>=dev-libs/dbus-glib-0.6
	x11-libs/libSM"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9
	>=app-text/gnome-doc-utils-0.3.2"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

src_prepare() {
	gnome2_src_prepare
	epatch "${FILESDIR}"/${PN}-2.22.0-default_shell.patch
}
