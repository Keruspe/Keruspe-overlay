# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2-live

DESCRIPTION="Compatibility library for accessing secrets"
HOMEPAGE="http://live.gnome.org/GnomeKeyring"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc test"

RDEPEND=">=sys-apps/dbus-1.0
	gnome-base/gconf
	>=gnome-base/gnome-keyring-3.1.92[test?]"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.9 )"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable test tests full)"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_prepare() {
	# FIXME: Remove silly CFLAGS
	sed -e 's:CFLAGS="$CFLAGS -Werror:CFLAGS="$CFLAGS:' \
		-e 's:CFLAGS="$CFLAGS -g -O0:CFLAGS="$CFLAGS:' \
		-i configure.ac || die "sed failed"
	# FIXME: Remove DISABLE_DEPRECATED flags
	sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' \
		-i configure.ac || die "sed 2 failed"
	gnome2_src_prepare
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	dbus-launch emake check || die "tests failed"
}
