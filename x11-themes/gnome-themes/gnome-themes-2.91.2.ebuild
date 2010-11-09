# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit eutils gnome2

DESCRIPTION="A set of GNOME themes, with sets for users with limited or low vision"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="accessibility"

RDEPEND="x11-libs/gtk+:3
	x11-themes/gtk-engines:3"
DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.7
	>=dev-util/pkgconfig-0.19
	>=dev-util/intltool-0.35
	sys-devel/gettext"

RESTRICT="binchecks strip"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable accessibility all-themes)
		--disable-test-themes
		--enable-icon-mapping"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_prepare() {
	gnome2_src_prepare
	epatch "${FILESDIR}/${PN}-2.24.3-bashism.patch"
	if ! use accessibility; then
		sed 's:HighContrast.*\\:\\:g' -i \
			desktop-themes/Makefile.am desktop-themes/Makefile.in \
			gtk-themes/Makefile.am gtk-themes/Makefile.in \
			icon-themes/Makefile.am icon-themes/Makefile.in \
			|| die "sed failed"
	fi
}
