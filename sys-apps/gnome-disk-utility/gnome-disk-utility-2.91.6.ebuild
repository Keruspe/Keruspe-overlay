# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit autotools eutils gnome2

DESCRIPTION="Disk Utility for GNOME using devicekit-disks"
HOMEPAGE="http://git.gnome.org/browse/gnome-disk-utility"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fat gnome-keyring nautilus remote-access"

CDEPEND="
	>=dev-libs/glib-2.22:2
	>=dev-libs/dbus-glib-0.74
	dev-libs/libunique:3
	>=x11-libs/gtk+-2.90.7:3
	=sys-fs/udisks-1.0*[remote-access?]
	>=dev-libs/libatasmart-0.14
	>=x11-libs/libnotify-0.6.1
	>=net-dns/avahi-0.6.28-r300[gtk3]
	gnome-keyring? ( || (
		gnome-base/libgnome-keyring
		<gnome-base/gnome-keyring-2.29.4 ) )
	nautilus? ( >=gnome-base/nautilus-2.24 )
"
RDEPEND="${CDEPEND}
	x11-misc/xdg-utils
	fat? ( sys-fs/dosfstools )
	!!sys-apps/udisks"
DEPEND="${CDEPEND}
	sys-devel/gettext
	gnome-base/gnome-common
	app-text/scrollkeeper
	app-text/gnome-doc-utils

	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.13

	doc? ( >=dev-util/gtk-doc-1.3 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable nautilus)
		$(use_enable remote-access)
		$(use_enable gnome-keyring)"
	DOCS="AUTHORS NEWS README TODO"
}

src_install() {
	gnome2_src_install
	find "${ED}" -name "*.la" -delete || die "remove of la files failed"
}
