# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="python? 2:2.5"
inherit git autotools gnome2 multilib python virtualx eutils

DESCRIPTION="Music management and playback software for GNOME"
HOMEPAGE="http://www.rhythmbox.org/"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="cdr daap dbus doc gnome-keyring html ipod +lastfm libnotify lirc
musicbrainz mtp nsplugin python test udev upnp vala webkit"

EGIT_REPO_URI="git://git.gnome.org/${PN}"
SRC_URI=""

COMMON_DEPEND=">=dev-libs/glib-2.25.12
	dev-libs/libxml2
	>=x11-libs/gtk+-2.91.4:3
	>=dev-libs/totem-pl-parser-2.32.1
	>=gnome-base/gconf-2
	>=gnome-extra/gnome-media-2.14
	>=net-libs/libsoup-2.26:2.4
	>=net-libs/libsoup-gnome-2.26:2.4
	>=media-libs/gst-plugins-base-0.10.24
	
	>=dev-libs/gobject-introspection-0.10.0

	cdr? (
		>=app-cdr/brasero-2.31.5 )
	daap? (
		>=media-libs/libdmapsharing-2.1.6
		>=net-dns/avahi-0.6 )
	html? ( >=net-libs/webkit-gtk-1.1.17:3 )
	gnome-keyring? ( >=gnome-base/gnome-keyring-0.4.9 )
	lastfm? ( dev-libs/json-glib )
	libnotify? ( >=x11-libs/libnotify-0.4.1 )
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
		>=dev-python/gconf-python-2.22
		>=dev-python/libgnome-python-2.22
		>=dev-python/gnome-keyring-python-2.22
		>=dev-python/gst-python-0.10.8
		webkit? (
			dev-python/mako
			dev-python/pywebkitgtk )
		upnp? (
			dev-python/louie
			media-video/coherence
			dev-python/twisted[gtk] ) )
"
# gtk-doc-am needed for eautoreconf
#	dev-util/gtk-doc-am
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.40
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.9.1
	doc? ( >=dev-util/gtk-doc-1.4 )
	test? ( dev-libs/check )
	vala? ( >=dev-lang/vala-0.11.0:0.12 )
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

	G2CONF="${G2CONF}
		MOZILLA_PLUGINDIR=/usr/$(get_libdir)/nsbrowser/plugins
		VALAC=$(type -P valac-0.12)
		--enable-mmkeys
		--disable-scrollkeeper
		--disable-schemas-install
		--disable-static
		$(use_enable daap)
		$(use_enable lastfm)
		$(use_enable libnotify)
		$(use_enable lirc)
		$(use_enable musicbrainz)
		$(use_enable nsplugin browser-plugin)
		$(use_enable python)
		$(use_enable vala)
		$(use_with daap mdns avahi)
		$(use_with gnome-keyring)
		$(use_with html webkit)
		$(use_with ipod)
		$(use_with mtp)
		$(use_with udev gudev)
		$(use_with cdr brasero)"

	export GST_INSPECT=/bin/true
}

src_unpack() {
	git_src_unpack
}

src_prepare() {
	gnome2_src_prepare
	gtkdocize
	gnome-doc-prepare --automake
	intltoolize --automake
	eautoreconf
	ln -s $(type -P true) py-compile
}

src_compile() {
	addpredict "$(unset HOME; echo ~)/.gconf"
	addpredict "$(unset HOME; echo ~)/.gconfd"
	gnome2_src_compile
}

src_test() {
	unset SESSION_MANAGER
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "test failed"
}

src_install() {
	gnome2_src_install
	find "${D}/usr/$(get_libdir)/rhythmbox/plugins" -name "*.la" -delete \
		|| die "failed to remove *.la files"
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
	python_mod_cleanup /usr/lib*/rhythmbox/plugins
}
