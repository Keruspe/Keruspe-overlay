# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils gnome2 git

EGIT_REPO_URI="git://git.gnome.org/gnome-shell"

DESCRIPTION="Provides core UI functions for the GNOME 3 desktop"
HOMEPAGE="http://live.gnome.org/GnomeShell"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+seconds"

RDEPEND=">=dev-libs/glib-2.20
	>=x11-libs/gtk+-2.16
	>=media-libs/gstreamer-0.10.16
	>=media-libs/gst-plugins-base-0.10.16
	>=gnome-base/gnome-desktop-2.26
	>=dev-libs/gobject-introspection-0.6.9
	
	dev-libs/dbus-glib
	>=dev-libs/gjs-0.6
	media-libs/clutter:1.0[opengl,introspection]

	gnome-base/gconf
	gnome-base/gnome-menus
	gnome-base/librsvg

	x11-libs/startup-notification
	x11-libs/libXfixes
	x11-apps/mesa-progs
	>=x11-wm/mutter-2.29.1[introspection]
"
DEPEND="${RDEPEND}
	>=dev-lang/python-2.5
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.26
	gnome-base/gnome-common
"
DOCS="AUTHORS README"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	mkdir m4
	use seconds && epatch ${FILESDIR}/show-seconds.patch
	intltoolize --force --copy --automake || die
	eautoreconf
}

pkg_postinst() {

	elog " Start with 'gnome-shell --replace' "
	elog " or add gnome-shell.desktop to ~/.config/autostart/ "

	gnome2_pkg_postinst

}
