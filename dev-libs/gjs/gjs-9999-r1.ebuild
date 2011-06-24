# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2"

inherit eutils gnome2-live python virtualx

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="http://live.gnome.org/Gjs"

LICENSE="MIT MPL-1.1 LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

# Things are untested and broken with anything other than xulrunner-2.0
RDEPEND=">=dev-libs/glib-2.18:2
	>=dev-libs/gobject-introspection-0.10.1

	dev-libs/dbus-glib
	sys-libs/readline
	x11-libs/cairo
	|| ( ~www-client/firefox-9999 >=net-libs/xulrunner-2.0 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9"

src_prepare() {
	# AUTHORS, ChangeLog are empty
	DOCS="NEWS README"
	# FIXME: add systemtap/dtrace support, like in glib:2
	G2CONF="${G2CONF}
		--disable-systemtap
		--disable-dtrace
		--disable-coverage"

	gnome2_src_prepare
	python_convert_shebangs 2 "${S}"/scripts/make-tests
}

src_test() {
	# Tests need dbus
	Xemake check || die
}

src_install() {
	# installation sometimes fails in parallel
	gnome2_src_install -j1

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins ${S}/examples/* || die "doins examples failed!"
	fi
}
