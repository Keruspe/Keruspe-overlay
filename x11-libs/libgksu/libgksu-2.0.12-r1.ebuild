# Copyright 1999-2010 Gentoo Foundation
# Copyright 2009-2010 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="A library for integration of su into applications"
HOMEPAGE="http://www.nongnu.org/gksu/"
SRC_URI="http://people.debian.org/~kov/gksu/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="nls doc"

RDEPEND=">=x11-libs/gtk+-2.12
	>=gnome-base/gconf-2
	>=gnome-base/gnome-keyring-0.4.4
	x11-libs/startup-notification
	>=gnome-base/libgtop-2
	nls? ( >=sys-devel/gettext-0.14.1 )"

DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.2-r1 )
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35.5
	>=dev-util/pkgconfig-0.19"

DOCS="AUTHORS ChangeLog"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable nls)"
}

src_unpack() {
	gnome2_src_unpack

	epatch "${FILESDIR}"/${PN}-2.0.0-fbsd.patch
	epatch "${FILESDIR}/${PN}-2.0.7-libs.patch"
	epatch "${FILESDIR}/${PN}-2.0.7-polinguas.patch"
	epatch "${FILESDIR}/${P}-revert-forkpty.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}
