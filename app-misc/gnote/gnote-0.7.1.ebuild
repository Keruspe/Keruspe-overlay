# Copyright 1999-2010 Gentoo Foundation
# Copyright 2009-2010 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2

DESCRIPTION="Desktop note-taking application"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="applet debug"

RDEPEND=">=x11-libs/gtk+-2.14
	>=dev-cpp/glibmm-2
	>=dev-cpp/gtkmm-2.12
	>=dev-libs/libxml2-2
	dev-libs/libxslt
	>=gnome-base/gconf-2
	>=dev-libs/libpcre-7.8[cxx]
	>=app-text/gtkspell-2.0.9
	>=dev-libs/boost-1.34
	sys-libs/e2fsprogs-libs
	applet? ( >=dev-cpp/libpanelappletmm-2.26
		>=gnome-base/gnome-panel-2 )"
DEPEND="${DEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35.0
	app-text/gnome-doc-utils
	app-text/docbook-xml-dtd:4.1.2"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable applet)
		$(use_enable debug)"
}
