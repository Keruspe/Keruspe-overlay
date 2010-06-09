# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit git autotools gnome2 multilib virtualx eutils

DESCRIPTION="Music management and playback software for GNOME"
HOMEPAGE="http://www.rhythmbox.org/"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"
IUSE="+brasero cdr daap gnome-keyring ipod libnotify lirc musicbrainz mtp nsplugin python test udev upnp webkit"
SLOT="0"

EGIT_REPO_URI="git://git.gnome.org/${PN}"
SRC_URI=""

COMMON_DEPEND=">=dev-libs/glib-2.18
	dev-libs/libxml2
	>=x11-libs/gtk+-2.16
	>=dev-libs/dbus-glib-0.71
	>=dev-libs/totem-pl-parser-2.26.0
	>=gnome-base/gconf-2
	>=gnome-extra/gnome-media-2.14.0
	>=net-libs/libsoup-2.26:2.4
	>=net-libs/libsoup-gnome-2.26:2.4

	>=media-libs/gst-plugins-base-0.10.20
	|| (
		>=media-libs/gst-plugins-base-0.10.24
		>=media-libs/gst-plugins-bad-0.10.6 )

	cdr? (
		brasero? ( >=app-cdr/brasero-0.9.1 )
		!brasero? ( >=gnome-extra/nautilus-cd-burner-2.21.6 ) )
	daap? ( >=net-dns/avahi-0.6 
		media-libs/libdmapsharing )
	gnome-keyring? ( >=gnome-base/gnome-keyring-0.4.9 )
	udev? (
		ipod? ( >=media-libs/libgpod-0.6 )
		mtp? ( >=media-libs/libmtp-0.3.0 )
		>=sys-fs/udev-145[extras] )
	ipod? ( >=media-libs/libgpod-0.6 )
	mtp? ( >=media-libs/libmtp-0.3.0 )
	libnotify? ( >=x11-libs/libnotify-0.4.1 )
	lirc? ( app-misc/lirc )
	musicbrainz? ( media-libs/musicbrainz:3 )
	python? (
		>=dev-lang/python-2.4.2
		|| (
			>=dev-lang/python-2.5
			dev-python/celementtree )
		>=dev-python/pygtk-2.8
		>=dev-python/pygobject-2.15.4
		>=dev-python/gconf-python-2.22
		>=dev-python/libgnome-python-2.22
		>=dev-python/gnome-keyring-python-2.22
		>=dev-python/gst-python-0.10.8
		webkit? (
			dev-python/mako
			dev-python/pywebkitgtk )
		upnp? ( media-video/coherence )
	)"

RDEPEND="${COMMON_DEPEND}
	>=media-plugins/gst-plugins-soup-0.10
	>=media-plugins/gst-plugins-libmms-0.10
	|| (
		>=media-plugins/gst-plugins-cdparanoia-0.10
		>=media-plugins/gst-plugins-cdio-0.10 )
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	>=media-plugins/gst-plugins-taglib-0.10.6
	nsplugin? ( net-libs/xulrunner )"

DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.40
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.9.1
	>=dev-util/gtk-doc-1.4
	test? ( dev-libs/check )"

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
		if use webkit; then
			ewarn "You need python support in addition to webkit to be able to use"
			ewarn "the context panel plugin."
		fi

		if use upnp; then
			ewarn "You need python support in addition to upnp"
		fi
	fi

	if use brasero; then
		G2CONF="${G2CONF} $(use_with cdr libbrasero-media) --without-libnautilus-burn"
	else
		G2CONF="${G2CONF} $(use_with cdr libnautilus-burn) --without-libbrasero-media"
	fi

	G2CONF="${G2CONF}
		MOZILLA_PLUGINDIR=/usr/$(get_libdir)/nsbrowser/plugins
		$(use_with gnome-keyring)
		$(use_with udev gudev)
		$(use_with ipod)
		$(use_enable libnotify)
		$(use_enable lirc)
		$(use_enable musicbrainz)
		$(use_with mtp)
		$(use_enable nsplugin browser-plugin)
		$(use_enable python)
		$(use_enable daap)
		$(use_with daap mdns avahi)
		--enable-mmkeys
		--disable-scrollkeeper
		--disable-schemas-install
		--disable-static
		--disable-vala"

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
	ewarn
	ewarn "If ${PN} doesn't play some music format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn
}

pkg_postrm() {
	gnome2_pkg_postrm
}
