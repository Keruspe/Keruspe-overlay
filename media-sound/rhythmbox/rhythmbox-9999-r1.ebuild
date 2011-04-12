# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="python? 2:2.5"

inherit eutils gnome2-live python multilib virtualx

DESCRIPTION="Music management and playback software for GNOME"
HOMEPAGE="http://www.rhythmbox.org/"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="cdr daap dbus doc gnome-keyring html ipod +lastfm libnotify lirc
musicbrainz mtp nsplugin python test udev upnp vala webkit"

# FIXME: double check what to do with fm-radio plugin
# TODO: watchout for udev use flag changes
# FIXME: Zeitgesti python plugin
# NOTE:: Rhythmbox Uses dbus-glib, gdbus, and dbus-python right now
COMMON_DEPEND=">=dev-libs/glib-2.26.0:2
	dev-libs/libxml2:2
	>=x11-libs/gtk+-2.91.4:3[introspection]
	>=x11-libs/gdk-pixbuf-2.18.0
	>=dev-libs/dbus-glib-0.71
	>=dev-libs/gobject-introspection-0.10.0
	>=dev-libs/totem-pl-parser-2.32.1
	>=media-libs/libgnome-media-profiles-2.91.0:3
	>=net-libs/libsoup-2.26:2.4
	>=net-libs/libsoup-gnome-2.26:2.4
	>=media-libs/gst-plugins-base-0.10.24:0.10
	media-libs/gstreamer:0.10[introspection]

	cdr? ( >=app-cdr/brasero-2.91.90 )
	daap? (
		net-libs/libdmapsharing:3.0
		>=net-dns/avahi-0.6 )
	gnome-keyring? ( >=gnome-base/gnome-keyring-0.4.9 )
	html? ( >=net-libs/webkit-gtk-1.3.9:3 )
	lastfm? ( dev-libs/json-glib )
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
	lirc? ( app-misc/lirc )
	musicbrainz? ( media-libs/musicbrainz:3 )
	udev? (
		ipod? ( >=media-libs/libgpod-0.7.92[udev] )
		mtp? ( >=media-libs/libmtp-0.3 )
		>=sys-fs/udev-145[extras] )
"
RDEPEND="${COMMON_DEPEND}
	>=media-plugins/gst-plugins-soup-0.10
	>=media-plugins/gst-plugins-libmms-0.10
	|| (
		>=media-plugins/gst-plugins-cdparanoia-0.10
		>=media-plugins/gst-plugins-cdio-0.10 )
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	>=media-plugins/gst-plugins-taglib-0.10.6

	nsplugin? ( net-libs/xulrunner )
	python? (
		>=dev-python/pygobject-2.15.4
		>=dev-python/gst-python-0.10.8

		x11-libs/gdk-pixbuf:2[introspection]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]

		dbus? ( dev-python/dbus-python )
		gnome-keyring? ( dev-python/gnome-keyring-python )
		webkit? (
			dev-python/mako
			net-libs/webkit-gtk:3[introspection] )
		upnp? (
			dev-python/louie
			media-video/coherence
			dev-python/twisted[gtk] ) )
"
# gtk-doc-am needed for eautoreconf
#	dev-util/gtk-doc-am
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.9.1
	doc? ( >=dev-util/gtk-doc-1.4 )
	test? ( dev-libs/check )
	vala? ( >=dev-lang/vala-0.12.0:0.12 )
"
DOCS="AUTHORS ChangeLog DOCUMENTERS INTERNALS \
	  MAINTAINERS MAINTAINERS.old NEWS README THANKS"

pkg_setup() {
	if ! use udev; then
		if use ipod; then
			ewarn "ipod support requires udev support.  Please"
			ewarn "re-emerge with USE=udev to enable ipod support"
		fi

		if use mtp; then
			ewarn "MTP support requires udev support.  Please"
			ewarn "re-emerge with USE=udev to enable MTP support"
		fi
	fi

	if ! use cdr ; then
		ewarn "You have cdr USE flag disabled."
		ewarn "You will not be able to burn CDs."
	fi

	if ! use python; then
		if use dbus; then
			ewarn "You need python support to use the im-status plugin"
		fi

		if use webkit; then
			ewarn "You need python support in addition to webkit to be able to use"
			ewarn "the context panel plugin."
		fi

		if use upnp; then
			ewarn "You need python support in addition to upnp"
		fi
	fi

	if use gnome-keyring && ! use python; then
		ewarn "The magnatune plugin requires USE='python gnome-keyring'"
	fi

	G2CONF="${G2CONF}
		MOZILLA_PLUGINDIR=/usr/$(get_libdir)/nsbrowser/plugins
		VALAC=$(type -P valac-0.12)
		--enable-mmkeys
		--disable-scrollkeeper
		--disable-schemas-compile
		--disable-static
		$(use_enable daap)
		$(use_enable lastfm)
		$(use_enable libnotify)
		$(use_enable lirc)
		$(use_enable musicbrainz)
		$(use_enable nsplugin browser-plugin)
		$(use_enable python)
		$(use_enable vala)
		$(use_with cdr brasero)
		$(use_with daap mdns avahi)
		$(use_with gnome-keyring)
		$(use_with html webkit)
		$(use_with ipod)
		$(use_with mtp)
		$(use_with udev gudev)"

	export GST_INSPECT=/bin/true
}

src_prepare() {
	gnome2_src_prepare

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

src_test() {
	unset SESSION_MANAGER
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "test failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use python; then
		python_need_rebuild
		python_mod_optimize /usr/$(get_libdir)/rhythmbox/plugins
	fi

	ewarn
	ewarn "If ${PN} doesn't play some music format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/rhythmbox/plugins
}
