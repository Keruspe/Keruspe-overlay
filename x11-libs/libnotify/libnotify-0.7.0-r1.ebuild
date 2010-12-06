# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome.org

DESCRIPTION="Notifications library"
HOMEPAGE="http://www.galago-project.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.26:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	test? ( x11-libs/gtk+:3 )"
PDEPEND="|| ( gnome-base/gnome-shell
	x11-misc/notification-daemon
	xfce-extra/xfce4-notifyd )"

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS
}
