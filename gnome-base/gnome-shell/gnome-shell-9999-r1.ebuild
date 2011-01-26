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
IUSE="bluetooth"

COMMON_DEPEND=">=dev-libs/glib-2.25.9
	>=x11-libs/gtk+-2.91.7:3[introspection]
	>=media-libs/clutter-1.5.15[introspection]
	>=gnome-base/gnome-desktop-2.91.2:3
	>=dev-libs/gobject-introspection-0.10.1

	dev-libs/dbus-glib
	>=dev-libs/gjs-0.7.8
	dev-libs/libxml2:2
	x11-libs/pango[introspection]
	dev-libs/libcroco:0.6

	x11-themes/gnome-icon-theme-symbolic
	x11-themes/gnome-themes-standard

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
	>=x11-wm/mutter-2.91.4[introspection]
	x11-apps/mesa-progs

	dev-python/dbus-python"
RDEPEND="${COMMON_DEPEND}
	x11-libs/gdk-pixbuf[introspection]
	>=gnome-base/dconf-0.4.1
	>=gnome-base/gnome-settings-daemon-2.91
	>=gnome-base/gnome-control-center-2.91
	>=gnome-base/libgnomekbd-2.91.4[introspection]"
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
	mkdir m4
	epatch ${FILESDIR}/0001-whitelist-dropbox-and-parcellite.patch
	intltoolize --force --copy --automake || die
	eautoreconf
}

src_install() {
	gnome2_src_install
	python_convert_shebangs 2 "${ED}"usr/bin/gnome-shell
	find "${ED}" -name "*.la" -delete || die "la files removal failed"
}
