# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2 multilib

DESCRIPTION="Brasero (aka Bonfire) is yet another application to burn CD/DVD for the gnome desktop."
HOMEPAGE="http://www.gnome.org/projects/brasero"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="beagle +cdr +css doc introspection +libburn nautilus playlist test"

COMMON_DEPEND=">=dev-libs/glib-2.15.6:2
	>=x11-libs/gtk+-2.16:2
	>=gnome-base/gconf-2
	>=media-libs/gstreamer-0.10.15
	>=media-libs/gst-plugins-base-0.10
	>=dev-libs/libxml2-2.6
	>=dev-libs/libunique-1
	>=dev-libs/dbus-glib-0.7.2
	beagle? ( >=dev-libs/libbeagle-0.3 )
	libburn? (
		>=dev-libs/libburn-0.4
		>=dev-libs/libisofs-0.6.4 )
	nautilus? ( >=gnome-base/nautilus-2.22.2 )
	introspection? ( dev-libs/gobject-introspection )
	playlist? ( >=dev-libs/totem-pl-parser-2.22 )"
RDEPEND="${COMMON_DEPEND}
	app-cdr/cdrdao
	app-cdr/dvd+rw-tools
	media-plugins/gst-plugins-meta
	css? ( media-libs/libdvdcss )
	cdr? ( virtual/cdrtools )
	!libburn? ( virtual/cdrtools )"
DEPEND="${COMMON_DEPEND}
	app-text/gnome-doc-utils
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool
	doc? ( >=dev-util/gtk-doc-1.3 )
	test? ( app-text/docbook-xml-dtd:4.3 )"
PDEPEND="gnome-base/gvfs"

G2CONF="${G2CONF}
	--disable-schemas-install
	--disable-scrollkeeper
	--disable-caches
	--disable-dependency-tracking
	$(use_enable beagle search)
	$(use_enable introspection)
	$(use_enable cdr cdrtools)
	$(use_enable cdr cdrkit)
	$(use_enable libburn libburnia)
	$(use_enable nautilus)
	$(use_enable playlist)"

if ! use libburn; then
	G2CONF="${G2CONF} --enable-cdrtools --enable-cdrkit"
fi

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

src_install() {
	gnome2_src_install

	rm -f "${D}"/usr/$(get_libdir)/brasero/plugins/*.la
	rm -f "${D}"/usr/$(get_libdir)/nautilus/extensions-2.0/*.la
}

pkg_postinst() {
	gnome2_pkg_postinst

	echo
	elog "If ${PN} doesn't handle some music or video format, please check"
	elog "your USE flags on media-plugins/gst-plugins-meta"
}
