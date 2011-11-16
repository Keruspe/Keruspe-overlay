# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2:2.5"

inherit gnome2-live python

DESCRIPTION="Provides core UI functions for the GNOME 3 desktop"
HOMEPAGE="http://live.gnome.org/GnomeShell"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+recorder"

# gnome-desktop-2.91.2 is needed due to header changes, db82a33 in gnome-desktop
# FIXME: Automagic gnome-bluetooth[introspection] support.
# latest gsettings-desktop-schemas is needed due to commit 602fa1c6
# latest g-c-c is needed due to https://bugs.gentoo.org/show_bug.cgi?id=360057
# libXfixes-5.0 needed for pointer barriers
COMMON_DEPEND=">=dev-libs/glib-2.31.0:2
	>=dev-libs/gjs-1.29.18
	>=dev-libs/gobject-introspection-0.10.1
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/gtk+-3.0.0:3[introspection]
	>=media-libs/clutter-1.7.5:1.0[introspection]
	app-misc/ca-certificates
	>=dev-libs/folks-0.5.2
	>=dev-libs/json-glib-0.13.2
	>=gnome-base/gnome-desktop-2.91.2:3
	>=gnome-base/gsettings-desktop-schemas-2.91.91
	gnome-base/libgnome-keyring
	>=gnome-extra/evolution-data-server-2.91.6[introspection]
	>=media-libs/gstreamer-0.10.16:0.10
	>=media-libs/gst-plugins-base-0.10.16:0.10
	>=net-im/telepathy-logger-0.2.4[introspection]
	net-libs/libsoup:2.4[introspection]
	>=net-libs/telepathy-glib-0.15.5[introspection]
	>=net-misc/networkmanager-0.8.999[introspection]
	>=net-wireless/gnome-bluetooth-3.1.0[introspection]
	>=net-im/telepathy-mission-control-5.9.0
	>=sys-auth/polkit-0.100[introspection]
	>=x11-wm/mutter-3.2.1[introspection]

	dev-libs/libxml2:2
	x11-libs/pango[introspection]
	>=dev-libs/libcroco-0.6.2:0.6

	>=gnome-base/gnome-menus-3.1[introspection]
	gnome-base/librsvg
	media-libs/libcanberra
	media-sound/pulseaudio

	>=x11-libs/startup-notification-0.11
	x11-libs/libX11
	>=x11-libs/libXfixes-5.0"
# Runtime-only deps are probably incomplete and approximate.
# Each block:
# 1. Pull in polkit-0.101 for pretty authorization dialogs
# 2. Introspection stuff + dconf needed via imports.gi.*
# 3. gnome-session is needed for gnome-session-quit
# 4. Control shell settings
# 5. accountsservice is needed for GdmUserManager (0.6.14 needed for fast
#    user switching with gdm-3.1.x)
# 6. caribou needed for on-screen keyboard
RDEPEND="${COMMON_DEPEND}
	>=x11-themes/gnome-icon-theme-3.1.90
	>=x11-themes/gnome-icon-theme-symbolic-3.1.90
	>=x11-themes/gnome-themes-standard-3.1.90
	media-fonts/cantarell

	>=sys-auth/polkit-0.101[introspection]

	>=gnome-base/dconf-0.4.1
	>=gnome-base/libgnomekbd-2.91.4[introspection]
	sys-power/upower[introspection]

	>=gnome-base/gnome-session-2.91.91

	>=gnome-base/gnome-settings-daemon-2.91
	>=gnome-base/gnome-control-center-2.91.92-r1

	>=sys-apps/accountsservice-0.6.14

	>=app-accessibility/caribou-0.3

	recorder? ( media-plugins/gst-plugins-vp8 )"
DEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.17
	>=dev-util/pkgconfig-0.22
	>=dev-util/intltool-0.40
	gnome-base/gnome-common
	!!=dev-lang/spidermonkey-1.8.2*"
# libmozjs.so is picked up from /usr/lib while compiling, so block at build-time
# https://bugs.gentoo.org/show_bug.cgi?id=360413

pkg_setup() {
	DOCS="AUTHORS NEWS README"
	# Don't error out on warnings
	G2CONF="${G2CONF}
		--enable-compile-warnings=maximum
		--disable-schemas-compile
		--disable-jhbuild-wrapper-script
		--with-ca-certificates=${EPREFIX}/etc/ssl/certs/ca-certificates.crt
		BROWSER_PLUGIN_DIR=${EPREFIX}/usr/$(get_libdir)/nsbrowser/plugins"
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch ${FILESDIR}/0001-whitelist-notification-stuff.patch
    gnome2_src_prepare
	# Drop G_DISABLE_DEPRECATED for sanity on glib upgrades; bug #384765
	# Note: sed Makefile.in because it is generated from several Makefile.ams
	sed -e 's/-DG_DISABLE_DEPRECATED//g' \
		-i src/Makefile.in browser-plugin/Makefile.in || die "sed failed"
}

src_install() {
	gnome2_src_install
	python_convert_shebangs 2 "${D}"/usr/bin/gnome-shell-extension-tool
}
