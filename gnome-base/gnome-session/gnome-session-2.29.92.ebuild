# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=3

inherit eutils gnome2

DESCRIPTION="Gnome session manager"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="${SRC_URI}
	mirror://gentoo/${PN}-2.26.2-session-saving-button.patch.bz2
	branding? ( mirror://gentoo/gentoo-splash.png )"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="branding doc ipv6 +splash elibc_FreeBSD"

RDEPEND=">=dev-libs/glib-2.16
	>=x11-libs/gtk+-2.14.0
	>=dev-libs/dbus-glib-0.76
	>=gnome-base/gconf-2
	>=x11-libs/startup-notification-0.9
	|| ( sys-apps/upower >=sys-apps/devicekit-power-008 )
	elibc_FreeBSD? ( dev-libs/libexecinfo )

	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libX11
	x11-libs/libXtst
	x11-apps/xdpyinfo"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	>=sys-devel/gettext-0.10.40
	>=dev-util/pkgconfig-0.17
	>=dev-util/intltool-0.40
	!<gnome-base/gdm-2.20.4
	doc? (
		app-text/xmlto
		dev-libs/libxslt )"

DOCS="AUTHORS ChangeLog NEWS README"

G2CONF="${G2CONF}
	--docdir=/usr/share/doc/${PF}
	--with-default-wm=gnome-wm
	$(use_enable splash)
	$(use_enable doc docbook-docs)
	$(use_enable ipv6)"

if use branding && ! use splash; then
	ewarn "You have disabled splash but enabled branding support"
	ewarn "splash support has been auto-enabled for branding"
	G2CONF="${G2CONF} --enable-splash"
fi

src_prepare() {
	gnome2_src_prepare

	use branding && epatch "${FILESDIR}/${PN}-2.27.91-gentoo-branding.patch"
	epatch "${FILESDIR}/${P}-xsmp-stop-throw-error.patch"
	epatch "${FILESDIR}/${P}-do-not-keep-zombie-clients.patch"
}

src_install() {
	gnome2_src_install

	dodir /etc/X11/Sessions
	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/Gnome" || die "doexe failed"

	if use branding; then
		insinto /usr/share/pixmaps/splash/
		doins "${DISTDIR}/gentoo-splash.png" || die "doins failed"
	fi
}
