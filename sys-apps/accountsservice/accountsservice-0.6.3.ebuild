# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit gnome2 autotools

DESCRIPTION="D-Bus interfaces for querying and manipulating user account information"
HOMEPAGE="http://www.fedoraproject.org/wiki/Features/UserAccountDialog"
#SRC_URI="http://mclasen.fedorapeople.org/accounts/${P}.tar.bz2"
SRC_URI="http://cgit.freedesktop.org/${PN}/snapshot/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND="
	dev-libs/glib:2
	dev-libs/dbus-glib
	sys-auth/polkit"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-util/pkgconfig
	gnome-base/gnome-common
	sys-devel/gettext

	>=dev-util/intltool-0.40
	>=dev-util/gtk-doc-am-1.13

	doc? ( app-text/xmlto )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		$(use_enable doc docbook-docs)"
	DOCS="AUTHORS NEWS README TODO"
}

src_prepare() {
	eautoreconf
	intltoolize --force --automake
}
