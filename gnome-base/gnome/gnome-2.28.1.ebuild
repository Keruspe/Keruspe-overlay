# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Meta package for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="as-is"
SLOT="2.0"

KEYWORDS="~amd64 ~x86"

IUSE="accessibility cdr cups dvdr esd ldap mono"

S=${WORKDIR}

RDEPEND="
	>=dev-libs/glib-2.22.2
	>=x11-libs/gtk+-2.18.3
	>=dev-libs/atk-1.28.0
	>=x11-libs/pango-1.26.0

	>=dev-libs/libxml2-2.7.2
	>=dev-libs/libxslt-1.1.22

	>=media-libs/audiofile-0.2.6-r1
	esd? ( >=media-sound/esound-0.2.41 )
	>=x11-libs/libxklavier-3.6
	>=media-libs/libart_lgpl-2.3.20

	>=dev-libs/libIDL-0.8.13
	>=gnome-base/orbit-2.14.16

	>=x11-libs/libwnck-2.28.0
	>=x11-wm/metacity-2.28.0

	>=gnome-base/gnome-keyring-2.28.1
	>=app-crypt/seahorse-2.28.1

	>=gnome-base/gnome-vfs-2.24.2

	>=gnome-base/gnome-mime-data-2.18.0

	>=gnome-base/gconf-2.28.0
	>=net-libs/libsoup-2.28.1

	>=gnome-base/libbonobo-2.24.2
	>=gnome-base/libbonoboui-2.24.2
	>=gnome-base/libgnome-2.28.0
	>=gnome-base/libgnomeui-2.24.2
	>=gnome-base/libgnomecanvas-2.26.0
	>=gnome-base/libglade-2.6.4

	>=gnome-extra/bug-buddy-2.28.0
	>=gnome-base/libgnomekbd-2.28.0
	>=gnome-base/gnome-settings-daemon-2.28.1
	>=gnome-base/gnome-control-center-2.28.1

	>=gnome-base/gvfs-1.4.1
	>=gnome-base/nautilus-2.28.1

	>=media-libs/gstreamer-0.10.24
	>=media-libs/gst-plugins-base-0.10.24
	>=media-libs/gst-plugins-good-0.10.16
	>=gnome-extra/gnome-media-2.28.1
	>=media-sound/sound-juicer-2.28.0
	>=media-gfx/eog-2.28.1

	>=app-arch/file-roller-2.28.1
	>=gnome-extra/gcalctool-5.28.1

	>=gnome-extra/gconf-editor-2.28.0
	>=gnome-base/gdm-2.20.10-r2
	>=x11-libs/gtksourceview-2.8.1:2.0
	>=app-editors/gedit-2.28.0

	>=app-text/evince-2.28.1

	>=gnome-base/gnome-desktop-2.28.1
	>=gnome-base/gnome-session-2.28.0
	>=dev-libs/libgweather-2.28.0
	>=gnome-base/gnome-menus-2.28.0.1
	>=x11-themes/gnome-icon-theme-2.28.0
	>=x11-themes/gnome-themes-2.28.1

	>=x11-themes/gtk-engines-2.18.4
	>=x11-themes/gnome-backgrounds-2.28.0

	>=x11-libs/vte-0.22.2
	>=x11-terms/gnome-terminal-2.28.1

	>=gnome-extra/gucharmap-2.28.1
	>=gnome-base/libgnomeprint-2.18.6
	>=gnome-base/libgnomeprintui-2.18.4

	>=gnome-extra/gnome-games-2.26.3-r1
	>=gnome-base/librsvg-2.26.0

	>=gnome-extra/gnome-system-monitor-2.28.0
	>=gnome-base/libgtop-2.28.0

	>=x11-libs/startup-notification-0.9

	>=gnome-extra/gnome-user-docs-2.28.0
	>=gnome-extra/yelp-2.28.0
	>=gnome-extra/zenity-2.28.0

	>=net-analyzer/gnome-nettool-2.28.0

	cdr? (
		|| (
			>=app-cdr/brasero-2.28.2
			>=gnome-extra/nautilus-cd-burner-2.24.0 ) )
	dvdr? (
		|| (
			>=app-cdr/brasero-2.28.2
			>=gnome-extra/nautilus-cd-burner-2.24.0 ) )

	>=gnome-extra/gtkhtml-3.28.1

	>=net-misc/vino-2.28.1

	ldap? (
		>=net-voip/ekiga-3.2.6 )

	>=gnome-extra/gnome-screensaver-2.28.0

	>=net-misc/vinagre-2.28.1
	>=gnome-extra/swfdec-gnome-2.28.0

	accessibility? (
		>=gnome-extra/libgail-gnome-1.20.1
		>=gnome-extra/at-spi-1.28.1
		>=app-accessibility/dasher-4.10.1
		>=app-accessibility/gnome-mag-0.15.9
		>=app-accessibility/gnome-speech-0.4.25
		>=app-accessibility/gok-2.28.1
		>=app-accessibility/orca-2.28.1
		>=gnome-extra/mousetweaks-2.28.1 )
	cups? ( >=net-print/gnome-cups-manager-0.31-r2 )

	mono? ( >=app-misc/tomboy-1.0.0 )"

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
