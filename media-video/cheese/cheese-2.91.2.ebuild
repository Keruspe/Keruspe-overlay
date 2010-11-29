# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit gnome2

DESCRIPTION="A cheesy program to take pictures and videos from your webcam"
HOMEPAGE="http://www.gnome.org/projects/cheese/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc v4l"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.7
	>=dev-libs/glib-2.26:2
	>=x11-libs/gtk+-2.19.1:2[jpeg]
	>=x11-libs/cairo-1.4
	>=x11-libs/pango-1.18
	>=sys-apps/dbus-1[X]
	>=sys-fs/udev-145-r1[extras]
	>=gnome-base/gconf-2.16
	>=gnome-base/gnome-desktop-2.26:2
	>=gnome-base/librsvg-2.18
	>=media-libs/libcanberra-0.23[gtk]

	>=dev-lang/vala-0.10:0.10
	>=media-libs/gstreamer-0.10.23
	>=media-libs/gst-plugins-base-0.10.23"
RDEPEND="${COMMON_DEPEND}
	>=media-plugins/gst-plugins-gconf-0.10
	>=media-plugins/gst-plugins-ogg-0.10.20
	>=media-plugins/gst-plugins-pango-0.10.20
	>=media-plugins/gst-plugins-theora-0.10.20
	>=media-plugins/gst-plugins-v4l2-0.10
	>=media-libs/gst-plugins-good-0.10.16
	>=media-plugins/gst-plugins-vorbis-0.10.20
	v4l? ( >=media-plugins/gst-plugins-v4l-0.10 )
	|| ( >=media-plugins/gst-plugins-x-0.10
		>=media-plugins/gst-plugins-xvideo-0.10 )"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	x11-proto/xf86vidmodeproto
	app-text/docbook-xml-dtd:4.3
	doc? ( >=dev-util/gtk-doc-1.11 )"

pkg_setup() {
	G2CONF="${G2CONF} --disable-scrollkeeper --disable-static"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_install() {
	gnome2_src_install
	find "${ED}" -name "*.la" -delete || die "la files removal failed"
}
