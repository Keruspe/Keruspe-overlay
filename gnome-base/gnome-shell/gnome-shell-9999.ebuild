# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils gnome2 git python

EGIT_REPO_URI="git://git.gnome.org/gnome-shell"
DESCRIPTION="Provides core UI functions for the GNOME 3 desktop"
HOMEPAGE="http://live.gnome.org/GnomeShell"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.25.9
	>=x11-libs/gtk+-2.91.0:3[introspection]
	>=media-libs/gstreamer-0.10.16
	>=media-libs/gst-plugins-base-0.10.16
	gnome-base/gnome-desktop:3
	>=dev-libs/gobject-introspection-0.6.11
	gnome-base/gsettings-desktop-schemas
	dev-libs/dbus-glib
	>=dev-libs/gjs-0.7
	x11-libs/pango[introspection]
	>=media-libs/clutter-1.3.14[introspection]
	x11-libs/gdk-pixbuf
	dev-libs/libcroco:0.6
	>=dev-libs/libical-0.43

	x11-themes/gnome-icon-theme-symbolic
	x11-themes/gnome-themes-standard
	x11-themes/gtk-theme-engine-clearlooks

	>=gnome-base/dconf-0.4.1
	gnome-base/gnome-menus
	gnome-base/librsvg

	x11-libs/startup-notification
	x11-libs/libXfixes
	x11-apps/mesa-progs
	>=x11-wm/mutter-2.91.0[introspection]

	dev-python/dbus-python
"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.2.6
	>=dev-lang/python-2.5
	sys-devel/gettext
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.26
	gnome-base/gnome-common
"
DOCS="AUTHORS README"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	sed -i \
	's:libgnome-desktop/gnome-desktop-thumbnail.h:libgnomeui/gnome-desktop-thumbnail.h:' \
	src/st/st-texture-cache.c
	mkdir m4
	intltoolize --force --copy --automake || die
	eautoreconf
}

src_install() {
	gnome2_src_install
	python_convert_shebangs 2 "${ED}"usr/bin/gnome-shell
	find "${ED}" -name "*.la" -delete || die "la files removal failed"
}

pkg_postinst() {
	elog " Start with 'gnome-shell --replace' "
	elog " or add gnome-shell.desktop to ~/.config/autostart/ "
	gnome2_pkg_postinst
}
