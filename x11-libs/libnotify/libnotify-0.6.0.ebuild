# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools gnome.org

DESCRIPTION="Notifications library"
HOMEPAGE="http://www.galago-project.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.6:2
	>=dev-libs/dbus-glib-0.76"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=x11-libs/gtk+-2.6:2"
PDEPEND="|| ( =gnome-base/gnome-shell-9999
	x11-misc/notification-daemon
	xfce-extra/xfce4-notifyd )"

src_prepare() {
	sed -i '/GTK3/d;/tests/d' configure.ac
	sed -i 's/tests//' Makefile.am
	eautoreconf
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS
}
