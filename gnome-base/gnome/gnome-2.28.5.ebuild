# Copyright 1999-2010 Gentoo Foundation
# Copyright 2009-2010 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

DESCRIPTION="Meta package for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="as-is"
SLOT="2.0"

KEYWORDS="~amd64 ~x86"

IUSE="accessibility cdr cups dvdr ldap mono mutter +note"

S=${WORKDIR}

RDEPEND="
	>=dev-libs/glib-2.22.3
	>=x11-libs/gtk+-2.18.5
	>=dev-libs/atk-1.28.0
	>=x11-libs/pango-1.26.2

	>=gnome-base/orbit-2.14.17

	>=x11-libs/libwnck-2.28.0
	!mutter? ( >=x11-wm/metacity-2.28.0 )
	mutter? ( >=x11-wm/mutter-2.28.0 )

	>=gnome-base/gnome-keyring-2.28.1
	>=app-crypt/seahorse-2.28.1

	>=gnome-base/gnome-vfs-2.24.2

	>=gnome-base/gnome-mime-data-2.18.0

	>=gnome-base/gconf-2.28.0-r1

	>=gnome-extra/bug-buddy-2.28.0
	>=gnome-base/gnome-settings-daemon-2.28.1
	>=gnome-base/gnome-control-center-2.28.1-r2

	>=gnome-base/gvfs-1.4.3
	>=gnome-base/nautilus-2.28.4

	>=media-libs/gstreamer-0.10.25
	>=media-libs/gst-plugins-base-0.10.25
	>=media-libs/gst-plugins-good-0.10.17
	>=gnome-extra/gnome-media-2.28.1
	>=media-sound/sound-juicer-2.28.1

	>=media-gfx/eog-2.28.2

	>=www-client/epiphany-2.28.2
	>=app-arch/file-roller-2.28.2
	>=gnome-extra/gcalctool-5.28.2

	>=gnome-extra/gconf-editor-2.28.0
	>=gnome-base/gdm-2.28.2
	>=x11-libs/gtksourceview-2.8.2:2.0
	>=app-editors/gedit-2.28.3

	>=app-text/evince-2.28.2

	>=gnome-base/gnome-desktop-2.28.2
	>=gnome-base/gnome-session-2.28.0
	>=gnome-base/gnome-menus-2.28.0.1
	>=x11-themes/gnome-icon-theme-2.28.0
	>=x11-themes/gnome-themes-2.28.1

	>=x11-themes/gtk-engines-2.18.4
	>=x11-themes/gnome-backgrounds-2.28.0

	>=x11-libs/vte-0.22.5
	>=x11-terms/gnome-terminal-2.28.2

	>=gnome-extra/gucharmap-2.28.2

	>=gnome-extra/gnome-utils-2.28.1

	>=gnome-extra/gnome-games-2.26.3-r1

	>=gnome-extra/gnome-system-monitor-2.28.0

	>=x11-libs/startup-notification-0.10

	>=gnome-extra/gnome-user-docs-2.28.1
	>=gnome-extra/yelp-2.28.1-r1
	>=gnome-extra/zenity-2.28.0

	>=net-analyzer/gnome-nettool-2.28.0

	cdr? ( >=app-cdr/brasero-2.28.3 )
	dvdr? (	>=app-cdr/brasero-2.28.3 )

	>=gnome-extra/gtkhtml-3.28.2
	>=mail-client/evolution-2.28.2
	>=gnome-extra/evolution-data-server-2.28.2
	>=gnome-extra/evolution-webcal-2.28.0

	>=net-misc/vino-2.28.1

	>=app-admin/pessulus-2.28.0
	ldap? (
		>=app-admin/sabayon-2.28.1
		>=net-voip/ekiga-3.2.6 )

	>=gnome-extra/gnome-screensaver-2.28.0
	>=gnome-extra/gnome-power-manager-2.28.2
	>=gnome-base/gnome-volume-manager-2.24.1
	
	>=net-misc/vinagre-2.28.1
	>=gnome-extra/swfdec-gnome-2.28.0-r1

	accessibility? (
		>=gnome-extra/at-spi-1.28.1
		>=app-accessibility/dasher-4.10.1
		>=app-accessibility/gnome-mag-0.15.9
		>=app-accessibility/gnome-speech-0.4.25
		>=app-accessibility/gok-2.28.1
		>=app-accessibility/orca-2.28.2
		>=gnome-extra/mousetweaks-2.28.2 )
	
	cups? ( >=net-print/gnome-cups-manager-0.33-r1 )

	note? (
		mono? ( >=app-misc/tomboy-1.0.0 )
		!mono? ( >=app-misc/gnote-0.6.3 ) )

	>=app-admin/gnome-system-tools-2.28.1
	>=app-admin/system-tools-backends-2.8.3"

pkg_postinst() {
	elog "The main file alteration monitoring functionality is"
	elog "provided by >=glib-2.16. Note that on a modern Linux system"
	elog "you do not need the USE=fam flag on it if you have inotify"
	elog "support in your linux kernel ( >=2.6.13 ) enabled."
	elog "USE=fam on glib is however useful for other situations,"
	elog "such as Gentoo/FreeBSD systems. A global USE=fam can also"
	elog "be useful for other packages that do not use the new file"
	elog "monitoring API yet that the new glib provides."
	elog
	elog
	elog "Add yourself to the plugdev group if you want"
	elog "automounting to work."
	elog
}
