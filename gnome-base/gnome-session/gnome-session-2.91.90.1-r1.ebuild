# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit autotools eutils gnome2

DESCRIPTION="Gnome session manager"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc ipv6 elibc_FreeBSD"

COMMON_DEPEND=">=dev-libs/glib-2.16:2
	>=x11-libs/gtk+-2.90.7:3
	>=dev-libs/dbus-glib-0.76
	>=gnome-base/gconf-2
	>=sys-power/upower-0.9.0
	gnome-base/librsvg:2
	elibc_FreeBSD? ( dev-libs/libexecinfo )

	virtual/opengl
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXtst
	x11-misc/xdg-user-dirs
	x11-misc/xdg-user-dirs-gtk
	x11-apps/xdpyinfo"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gnome-settings-daemon
	gnome-base/gnome-shell"
PDEPEND="gnome-base/gnome-shell"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=sys-devel/gettext-0.10.40
	>=dev-util/pkgconfig-0.17
	>=dev-util/intltool-0.40
	!<gnome-base/gdm-2.20.4
	doc? (
		app-text/xmlto
		dev-libs/libxslt )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-deprecation-flags
		--disable-maintainer-mode
		--disable-schemas-compile
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		--with-gtk=3.0
		$(use_enable doc docbook-docs)
		$(use_enable ipv6)"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_prepare() {
	gnome2_src_prepare
	epatch "${FILESDIR}/${PN}-2.32.0-session-saving-button.patch"
	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

src_install() {
	gnome2_src_install
	dodir /etc/X11/Sessions || die "dodir failed"
	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/Gnome" || die "doexe failed"
	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/10-user-dirs-update" || die "doexe failed"
}

pkg_postinst() {
	if ! has_version gnome-base/gdm && ! has_version kde-base/kdm; then
		ewarn "If you use a custom .xinitrc for your X session,"
		ewarn "make sure that the commands in the xinitrc.d scripts are run."
	fi
}
