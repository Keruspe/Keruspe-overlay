# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/brasero/brasero-2.32.0.ebuild,v 1.3 2010/10/20 20:25:40 eva Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit autotools eutils gnome2 multilib

DESCRIPTION="Brasero (aka Bonfire) is yet another application to burn CD/DVD for the gnome desktop."
HOMEPAGE="http://www.gnome.org/projects/brasero"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="beagle +cdr +css doc +introspection +libburn nautilus playlist test"

COMMON_DEPEND="
	>=dev-libs/glib-2.27.1
	media-libs/libcanberra[gtk3]
	>=x11-libs/gtk+-2.91.0:3[introspection?]
	>=gnome-base/gconf-2.31.1
	>=media-libs/gstreamer-0.10.15
	>=media-libs/gst-plugins-base-0.10
	>=dev-libs/libxml2-2.6
	>=dev-libs/libunique-1
	x11-libs/libSM
	beagle? ( >=dev-libs/libbeagle-0.3 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.3 )
	libburn? (
		>=dev-libs/libburn-0.4
		>=dev-libs/libisofs-0.6.4 )
	nautilus? ( >=gnome-base/nautilus-2.31.3[introspection?] )
	playlist? ( >=dev-libs/totem-pl-parser-2.29.1 )"
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
	gnome-base/gnome-common
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
		--with-gtk=2.0
		$(use_enable beagle search beagle)
		$(use_enable cdr cdrtools)
		$(use_enable cdr cdrkit)
		$(use_enable introspection)
		$(use_enable libburn libburnia)
		$(use_enable nautilus)
		$(use_enable playlist)"

	if ! use libburn; then
		G2CONF="${G2CONF} --enable-cdrtools --enable-cdrkit"
	fi

	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
}

src_prepare() {
	gnome2_src_prepare

	# Fix link against installed libraries, bug #340767
	epatch "${FILESDIR}/${PN}-2.32.0-build-plugins-against-local-library.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

src_install() {
	gnome2_src_install

	# Remove useless .la files
	rm -f "${ED}"/usr/$(get_libdir)/brasero/plugins/*.la
	rm -f "${ED}"/usr/$(get_libdir)/nautilus/extensions-2.0/*.la
}

pkg_preinst() {
	gnome2_pkg_preinst

	preserve_old_lib /usr/$(get_libdir)/libbrasero-burn.so.0
	preserve_old_lib /usr/$(get_libdir)/libbrasero-media.so.0
	preserve_old_lib /usr/$(get_libdir)/libbrasero-utils.so.0
}

pkg_postinst() {
	gnome2_pkg_postinst

	preserve_old_lib_notify /usr/$(get_libdir)/libbrasero-burn.so.0
	preserve_old_lib_notify /usr/$(get_libdir)/libbrasero-media.so.0
	preserve_old_lib_notify /usr/$(get_libdir)/libbrasero-utils.so.0

	echo
	elog "If ${PN} doesn't handle some music or video format, please check"
	elog "your USE flags on media-plugins/gst-plugins-meta"
}
