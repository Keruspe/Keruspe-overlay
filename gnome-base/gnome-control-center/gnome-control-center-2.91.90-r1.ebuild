# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=3
GCONF_DEBUG="yes"

inherit gnome2 eutils

DESCRIPTION="GNOME Desktop Configuration Tool"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"

IUSE="doc +networkmanager +socialweb"

COMMON_DEPEND="
	>=dev-libs/glib-2.25.11
	>=x11-libs/gdk-pixbuf-2.23.0
	>=x11-libs/gtk+-2.91.6:3
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	>=gnome-base/gconf-2.0
	>=dev-libs/dbus-glib-0.73
	>=gnome-base/gnome-desktop-2.91.5:3
	>=gnome-base/gnome-settings-daemon-2.91.9
	>=gnome-base/libgnomekbd-2.91.2

	app-admin/apg
	app-text/iso-codes
	dev-libs/libxml2:2
	gnome-base/gnome-menus
	gnome-base/libgtop:2
	media-libs/fontconfig
	media-libs/gstreamer:0.10

	>=media-libs/libcanberra-0.13[gtk3]
	>=media-sound/pulseaudio-0.9.16
	>=sys-auth/polkit-0.97
	>=sys-power/upower-0.9.1

	x11-apps/xmodmap
	x11-libs/libX11
	x11-libs/libXxf86misc
	>=x11-libs/libxklavier-5.1
	>=x11-libs/libXi-1.2

	networkmanager? ( >=net-misc/networkmanager-0.8.992 )
	socialweb? ( net-libs/libsocialweb )

	!gnome-extra/gnome-media[pulseaudio]
	!<gnome-extra/gnome-media-2.32.0-r300"
RDEPEND="${COMMON_DEPEND}
	sys-apps/accountsservice"
PDEPEND=">=gnome-base/gnome-session-2.91.6-r1"
DEPEND="${COMMON_DEPEND}
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto

	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.40.1
	>=dev-util/pkgconfig-0.19

	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.10.1
	doc? ( >=dev-util/gtk-doc-1.9 )"

src_prepare() {
	G2CONF="${G2CONF}
		--disable-update-mimedb
		--disable-static
		--disable-schemas-install
		$(use_with socialweb libsocialweb)"
	DOCS="AUTHORS ChangeLog NEWS README TODO"

	# bug 356729
	epatch "${FILESDIR}/${PN}-fix-networkmanager-api.patch"

	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	find "${ED}" -name "*.la" -delete || die "remove of la files failed"
}
