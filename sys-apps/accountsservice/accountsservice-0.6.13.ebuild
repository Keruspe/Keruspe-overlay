# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
inherit gnome2 systemd

DESCRIPTION="D-Bus interfaces for querying and manipulating user account information"
HOMEPAGE="http://www.fedoraproject.org/wiki/Features/UserAccountDialog"
SRC_URI="http://www.freedesktop.org/software/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection"

RDEPEND="
	dev-libs/glib:2
	dev-libs/dbus-glib
	sys-auth/polkit

	introspection? ( >=dev-libs/gobject-introspection-0.9.12 )"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-util/pkgconfig
	sys-devel/gettext
	>=dev-util/intltool-0.40"

# Documentaton doesn't validate
RESTRICT="test"

pkg_setup() {
	# docbook docs don't validate, disable doc rebuild
	G2CONF="${G2CONF}
		--disable-static
		--localstatedir=/var
		--disable-docbook-docs
		--disable-maintainer-mode
		--disable-more-warnings
		$(systemd_with_unitdir)
		$(use_enable introspection)"
	DOCS="AUTHORS NEWS README TODO"
}
