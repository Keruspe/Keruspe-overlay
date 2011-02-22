# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.5"
inherit autotools eutils gnome2 git python

EGIT_REPO_URI="git://git.gnome.org/gnome-shell"
DESCRIPTION="Provides core UI functions for the GNOME 3 desktop"
HOMEPAGE="http://live.gnome.org/GnomeShell"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth nm-applet"

COMMON_DEPEND=">=dev-libs/glib-2.25.9
	>=x11-libs/gtk+-3.0.0:3[introspection]
	>=media-libs/clutter-1.5.15[introspection]
	>=gnome-base/gnome-desktop-2.91.2:3
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	>=dev-libs/gobject-introspection-0.10.1
	>=gnome-extra/evolution-data-server-2.91.6[introspection]
	>=net-libs/telepathy-glib-0.13.12[introspection]

	dev-libs/dbus-glib
	>=dev-libs/gjs-0.7.11
	dev-libs/libxml2:2
	x11-libs/pango[introspection]
	dev-libs/libcroco:0.6

	gnome-base/gconf[introspection]
	gnome-base/gnome-menus
	gnome-base/librsvg
	>=media-libs/gstreamer-0.10.16
	>=media-libs/gst-plugins-base-0.10.16
	media-libs/libcanberra
	media-sound/pulseaudio
	bluetooth? ( >=net-wireless/gnome-bluetooth-2.91[introspection] )
	!bluetooth? ( !!net-wireless/gnome-bluetooth )

	x11-libs/startup-notification
	x11-libs/libXfixes
	>=x11-wm/mutter-2.91.6[introspection]
	x11-apps/mesa-progs

	dev-python/dbus-python
	dev-python/gconf-python"
RDEPEND="${COMMON_DEPEND}
	x11-themes/gnome-icon-theme-symbolic
	x11-themes/gnome-themes-standard
	media-fonts/cantarell

	x11-libs/gdk-pixbuf[introspection]
	>=gnome-base/dconf-0.4.1
	>=gnome-base/gnome-settings-daemon-2.91
	>=gnome-base/gnome-control-center-2.91
	>=gnome-base/libgnomekbd-2.91.4[introspection]

	nm-applet? ( >=gnome-extra/nm-applet-9999 )"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.26
	gnome-base/gnome-common"
DOCS="AUTHORS README"
G2CONF="--enable-compile-warnings=maximum
--disable-schemas-compile"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	if use nm-applet; then
		# See https://bugzilla.gnome.org/show_bug.cgi?id=621707"
		ewarn "Adding support for the experimental NetworkManager applet."
		ewarn "This needs the latest NetworkManager & nm-applet trunk."
		ewarn "Report bugs about this to 'nirbheek' on #gentoo-desktop @ FreeNode."
		epatch "${FILESDIR}/gnome-shell-experimental-nm-applet.patch"
	fi
	mkdir m4
	epatch ${FILESDIR}/0001-whitelist-notification-stuff.patch
	intltoolize --force --copy --automake || die
	eautoreconf
}

src_install() {
	gnome2_src_install
	python_convert_shebangs 2 "${ED}"usr/bin/gnome-shell
	find "${ED}" -name "*.la" -delete || die "la files removal failed"
}
