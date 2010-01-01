# Copyright 1999-2010 Gentoo Foundation
# Copyright 2009-2010 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit flag-o-matic versionator

DESCRIPTION="Canonical's on-screen-display notification agent."
HOMEPAGE="https://launchpad.net/notify-osd"
SRC_URI="http://launchpad.net/notify-osd/trunk/ubuntu-9.10/+download/notify-osd-0.9.24.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/dbus-glib-0.76
	>=dev-libs/glib-2.16.0
	gnome-base/gconf:2
	>=x11-libs/gtk+-2.6
	x11-libs/libwnck"
DEPEND="${RDEPEND}"

src_configure() {
	append-flags -fno-strict-aliasing
	default
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
