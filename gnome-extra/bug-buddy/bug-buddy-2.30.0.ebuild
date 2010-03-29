# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2

DESCRIPTION="A graphical bug reporting tool"
HOMEPAGE="http://www.gnome.org/"
LICENSE="Ximian-logos GPL-2"

SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="eds"

RDEPEND=">=dev-libs/glib-2.16.0
	>=dev-libs/libxml2-2.4.6
	>=x11-libs/gtk+-2.14.0
	>=net-libs/libsoup-2.4
	>=gnome-base/libgtop-2.13.3
	eds? ( >=gnome-extra/evolution-data-server-1.3 )
	>=gnome-base/gconf-2
	|| ( dev-libs/elfutils dev-libs/libelf )
	>=sys-devel/gdb-5.1"

DEPEND=${RDEPEND}"
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40"

DOCS="AUTHORS ChangeLog NEWS README TODO"

G2CONF="${G2CONF}
	--disable-google-breakpad
	$(use_enable eds)"
