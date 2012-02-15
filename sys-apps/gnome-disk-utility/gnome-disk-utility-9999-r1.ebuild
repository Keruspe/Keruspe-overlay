# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2-live

DESCRIPTION="Disk Utility for GNOME using devicekit-disks"
HOMEPAGE="http://git.gnome.org/browse/gnome-disk-utility"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc fat"
KEYWORDS=""

CDEPEND="
	>=dev-libs/glib-2.22:2
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/libunique-2.90.1:3
	>=x11-libs/gtk+-2.90.7:3
	>=sys-fs/udisks-1.92
	>=dev-libs/libatasmart-0.14
	>=x11-libs/libnotify-0.6.1
"
RDEPEND="${CDEPEND}
	x11-misc/xdg-utils
	fat? ( sys-fs/dosfstools )
	!!sys-apps/udisks"
DEPEND="${CDEPEND}
	sys-devel/gettext
	gnome-base/gnome-common
	app-text/docbook-xml-dtd:4.1.2
	app-text/scrollkeeper
	app-text/gnome-doc-utils

	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.13

	doc? ( >=dev-util/gtk-doc-1.3 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static"
	DOCS="AUTHORS NEWS README"
}

src_prepare() {
	if [[ ${PV} != 9999 ]]; then
		intltoolize --force --copy --automake || die
		eautoreconf
	fi

	gnome2_src_prepare
}
