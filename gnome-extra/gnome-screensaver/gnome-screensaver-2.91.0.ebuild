# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2 multilib

DESCRIPTION="Replaces xscreensaver, integrating with the desktop."
HOMEPAGE="http://live.gnome.org/GnomeScreensaver"
SRC_URI="${SRC_URI} branding? ( http://www.gentoo.org/images/gentoo-logo.svg )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
KERNEL_IUSE="kernel_linux"
IUSE="branding debug doc libnotify opengl pam ${KERNEL_IUSE}"

RDEPEND=">=gnome-base/gconf-2.6.1
	>=x11-libs/gtk+-2.91.1:3
	>=gnome-base/gnome-desktop-2.91.0
	>=gnome-base/gnome-menus-2.12
	>=dev-libs/glib-2.15
	>=gnome-base/libgnomekbd-0.1
	>=dev-libs/dbus-glib-0.71
	libnotify? ( x11-libs/libnotify )
	opengl? ( virtual/opengl )
	pam? ( virtual/pam )
	!pam? ( kernel_linux? ( sys-apps/shadow ) )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXScrnSaver
	x11-libs/libXxf86misc
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40
	doc? (
		app-text/xmlto
		~app-text/docbook-xml-dtd-4.1.2
		~app-text/docbook-xml-dtd-4.4 )
	x11-proto/xextproto
	x11-proto/randrproto
	x11-proto/scrnsaverproto
	x11-proto/xf86miscproto"

DOCS="AUTHORS ChangeLog HACKING NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable doc docbook-docs)
		$(use_enable debug)
		$(use_with libnotify)
		$(use_with opengl gl)
		$(use_enable pam)
		--enable-locking
		--with-xf86gamma-ext
		--with-kbd-layout-indicator
		--with-xscreensaverdir=/usr/share/xscreensaver/config
		--with-xscreensaverhackdir=/usr/$(get_libdir)/misc/xscreensaver"
}

src_prepare() {
	gnome2_src_prepare
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed failed"
}

src_install() {
	gnome2_src_install
	dodoc "${S}/data/migrate-xscreensaver-config.sh"
	dodoc "${S}/data/xscreensaver-config.xsl"
	sed -e "s:\${PF}:${PF}:" < "${FILESDIR}/xss-conversion-2.txt" \
		> "${S}/xss-conversion.txt" || die "sed failed"
	dodoc "${S}/xss-conversion.txt"
	if ! use pam ; then
		fperms u+s /usr/libexec/gnome-screensaver-dialog
	fi
	if use branding ; then
		insinto /usr/share/pixmaps/
		doins "${DISTDIR}/gentoo-logo.svg" || die "doins 1 failed"
		insinto /usr/share/applications/screensavers/
		doins "${FILESDIR}/gentoologo-floaters.desktop" || die "doins 2 failed"
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst
	if has_version "<x11-base/xorg-server-1.5.3-r4" ; then
		ewarn "You have a too old xorg-server installation. This will cause"
		ewarn "gnome-screensaver to eat up your CPU. Please consider upgrading."
		echo
	fi

	if has_version "<x11-misc/xscreensaver-4.22-r2" ; then
		ewarn "You have xscreensaver installed, you probably want to disable it."
		ewarn "To prevent a duplicate screensaver entry in the menu, you need to"
		ewarn "build xscreensaver with -gnome in the USE flags."
		ewarn "echo \"x11-misc/xscreensaver -gnome\" >> /etc/portage/package.use"

		echo
	fi

	elog "Information for converting screensavers is located in "
	elog "/usr/share/doc/${PF}/xss-conversion.txt.${PORTAGE_COMPRESS}"
}
