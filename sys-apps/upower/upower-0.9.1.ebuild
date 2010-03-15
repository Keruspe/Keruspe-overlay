# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools gnome2 linux-info

DESCRIPTION="D-Bus abstraction for enumerating power devices and querying history and statistics"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/DeviceKit"
SRC_URI="http://hal.freedesktop.org/releases/${P/up/UP}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc introspection test"

RDEPEND=">=dev-libs/glib-2.21.5
	>=dev-libs/dbus-glib-0.76
	>=sys-fs/udev-145[extras]
	>=sys-auth/polkit-0.91
	sys-apps/dbus
	virtual/libusb:0
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	dev-libs/libxslt
	dev-util/gtk-doc-am
	doc? (
		>=dev-util/gtk-doc-1.3
		app-text/docbook-xml-dtd:4.1.2 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
	app-text/docbook-xsl-stylesheets
	!sys-apps/devicekit-power
"

DOCS="AUTHORS HACKING NEWS"

S="${WORKDIR}/${P/up/UP}"

function check_battery() {
	local CONFIG_CHECK="ACPI_SYSFS_POWER"
	check_extra_config
}

G2CONF="${G2CONF}
	--localstatedir=/var
	--disable-ansi
	--disable-static
	--enable-man-pages
	$(use_enable debug verbose-mode)
	$(use_enable test tests)
"

pkg_setup() {
	check_battery
}

src_prepare() {
	gnome2_src_prepare
	sed 's:-DG.*DISABLE_DEPRECATED::g' -i configure.ac configure \
		|| die "sed 1 failed"
	sed 's:WARNINGFLAGS_C=\"$WARNINGFLAGS_C -Wtype-limits\"::g' -i configure.ac configure \
		|| die "sed 2 failed"
	if ! use introspection; then
		sed -i '16,17d' configure.ac
		sed -i '61,79d' libupower-glib/Makefile.am
	fi
	mkdir m4
	eautoreconf
}
