# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils gnome2

DESCRIPTION="PolicyKit policies and configurations for the GNOME desktop"
HOMEPAGE="http://hal.freedesktop.org/docs/PolicyKit"
SRC_URI="http://hal.freedesktop.org/releases/${P}.tar.bz2"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~sparc ~x86"
IUSE="doc examples introspection"

RDEPEND=">=x11-libs/gtk+-2.17.1
	>=gnome-base/gconf-2.8
	>=dev-libs/dbus-glib-0.71
	>=sys-auth/polkit-0.95
	introspection? ( >=dev-libs/gobject-introspection-0.6.2 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.19
	>=dev-util/intltool-0.35.0
	>=app-text/scrollkeeper-0.3.14
	gnome-base/gnome-common
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.3 )"

DOCS="AUTHORS HACKING NEWS TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable examples)
		$(use_enable introspection)"
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.95-fix-make-check.patch"

	if use doc; then
		epatch "${FILESDIR}/${PN}-0.95-parallel-build-failure.patch"
		gtkdocize || die "gtkdocize failed"
		eautoreconf
	fi
}
