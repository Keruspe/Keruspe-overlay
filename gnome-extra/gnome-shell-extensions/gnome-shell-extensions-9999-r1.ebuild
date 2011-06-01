# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2-live

DESCRIPTION="JavaScript Extensions for GNOME Shell"
HOMEPAGE="http://live.gnome.org/GnomeShell/Extensions"

LICENSE="GPL-2"
SLOT="0"
DEFAULT_EXTENSIONS="alternative-status-menu apps-menu dock drive-menu gajim
places-menu windowsNavigator"
ALL_EXTENSIONS="${DEFAULT_EXTENSIONS} alternate-tab auto-move-windows example
native-window-placement systemMonitor user-theme xrandr-indicator"
IUSE="${ALL_EXTENSIONS}"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.26
	>=gnome-base/gnome-desktop-2.91.6:3"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gnome-desktop:3[introspection]
	media-libs/clutter:1.0[introspection]
	net-libs/telepathy-glib[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]"
DEPEND="${COMMON_DEPEND}
	systemMonitor? ( gnome-base/libgtop )
	sys-devel/gettext
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.26
	gnome-base/gnome-common"

pkg_setup() {
	extensions=""
	for ext in ${ALL_EXTENSIONS}; do
		use ${ext} && extensions="${ext} ${extensions}"
	done
	DOCS="HACKING README"
}

src_prepare() {
	sed -i s/2\.28\.4/2.28.3/ configure.ac
	gnome2_src_prepare
}

src_configure() {
	econf --enable-extensions="${extensions}"
}
