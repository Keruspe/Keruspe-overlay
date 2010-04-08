# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2 virtualx

DESCRIPTION="a library for writing single instance application"
HOMEPAGE="http://live.gnome.org/LibUnique"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus doc introspection"

RDEPEND=">=dev-libs/glib-2.12.0
	>=x11-libs/gtk+-2.11.0
	x11-libs/libX11
	dbus? ( >=dev-libs/dbus-glib-0.70 )
	introspection? (
		>=dev-libs/gobject-introspection-0.6.3
		>=x11-libs/gtk+-2.20[introspection] )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.17
	doc? ( >=dev-util/gtk-doc-1.11 )"

DOCS="AUTHORS NEWS ChangeLog README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-maintainer-flags
		--disable-static
		--enable-bacon
		$(use_enable dbus)
		$(use_enable introspection)"
}

src_test() {
	cd "${S}/tests"
	unset DBUS_SESSION_BUS_ADDRESS
	unset XAUTHORITY
	unset DISPLAY
	cp "${FILESDIR}/run-tests" . || die "Unable to cp \${FILESDIR}/run-tests"
	Xemake -f run-tests || die "Tests failed"
}