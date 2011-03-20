# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome.org

DESCRIPTION="Notifications library"
HOMEPAGE="http://www.galago-project.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +introspection test"

RDEPEND=">=dev-libs/glib-2.26:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.12 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.14 )
	test? ( >=x11-libs/gtk+-2.90:3 )"
PDEPEND="|| (
	gnome-base/gnome-shell
	x11-misc/notification-daemon
	xfce-extra/xfce4-notifyd
	x11-misc/notify-osd
	>=x11-wm/awesome-3.4.4 )"

src_configure() {
	econf \
		--disable-static \
		--disable-dependency-tracking \
		$(use_enable test tests)
}

src_install() {
	emake install DESTDIR="${ED}" || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS || die "dodoc failed"
}
