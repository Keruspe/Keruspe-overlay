# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2-live multilib

DESCRIPTION="Brasero (aka Bonfire) is yet another application to burn CD/DVD for the gnome desktop."
HOMEPAGE="http://projects.gnome.org/brasero/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+css doc +introspection +libburn mp3 nautilus packagekit playlist test tracker"

COMMON_DEPEND="
	>=dev-libs/glib-2.29.14:2
	>=x11-libs/gtk+-3.0.0:3[introspection?]
	>=media-libs/gstreamer-0.10.15:0.10
	>=media-libs/gst-plugins-base-0.10:0.10
	>=dev-libs/libxml2-2.6:2
	>=x11-libs/libnotify-0.6.1

	media-libs/libcanberra[gtk3]
	x11-libs/libICE
	x11-libs/libSM

	introspection? ( >=dev-libs/gobject-introspection-0.6.3 )
	libburn? (
		>=dev-libs/libburn-0.4
		>=dev-libs/libisofs-0.6.4 )
	nautilus? ( >=gnome-base/nautilus-2.91.90 )
	playlist? ( >=dev-libs/totem-pl-parser-2.29.1 )
	tracker? ( >=app-misc/tracker-0.12 )"
RDEPEND="${COMMON_DEPEND}
	media-libs/gst-plugins-good:0.10
	media-plugins/gst-plugins-gconf:0.10
	media-plugins/gst-plugins-meta:0.10[mp3?]
	x11-themes/hicolor-icon-theme
	css? ( media-libs/libdvdcss:1.2 )
	!libburn? (
		app-cdr/cdrdao
		app-cdr/dvd+rw-tools
		virtual/cdrtools )
	mp3? ( media-libs/gst-plugins-ugly:0.10 )
	packagekit? ( app-admin/packagekit-base )"
DEPEND="${COMMON_DEPEND}
	app-text/gnome-doc-utils
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool
	gnome-base/gnome-common:3
	>=dev-util/gtk-doc-am-1.12
	doc? ( >=dev-util/gtk-doc-1.12 )
	test? ( app-text/docbook-xml-dtd:4.3 )"
# eautoreconf deps
#	gnome-base/gnome-common
#	dev-util/gtk-doc-am
PDEPEND="gnome-base/gvfs"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-caches
		--disable-dependency-tracking
		$(use_enable !libburn cdrtools)
		$(use_enable !libburn cdrkit)
		$(use_enable !libburn cdrdao)
		$(use_enable !libburn growisofs)
		$(use_enable introspection)
		$(use_enable libburn libburnia)
		$(use_enable nautilus)
		$(use_enable playlist)
		$(use_enable tracker search)"

	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
}

src_prepare() {
	gnome2_src_prepare
	touch plugins/libburnia/.gitignore.tmp
}

pkg_postinst() {
	gnome2_pkg_postinst

	echo
	elog "If ${PN} doesn't handle some music or video format, please check"
	elog "your USE flags on media-plugins/gst-plugins-meta"
}
