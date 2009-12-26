# Copyright 1999-2009 Gentoo Foundation
# Copyright 2009 Marc-Antoin Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Telepathy Mission Control"
HOMEPAGE="http://telepathy.freedesktop.org"
SRC_URI="http://telepathy.freedesktop.org/releases/telepathy-mission-control/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gnome-keyring test"

RDEPEND=">=net-libs/telepathy-glib-0.7.32
	>=dev-libs/dbus-glib-0.51
	>=gnome-base/gconf-2
	gnome-keyring? ( >=gnome-base/gnome-keyring-2.22 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-libs/libxslt
	doc? ( dev-util/gtk-doc )
	test? ( virtual/python
		dev-python/twisted-words )"

src_configure() {
	econf \
		$(use_enable doc gtk-doc)	
		$(use_enable gnome-keyring)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog
}
