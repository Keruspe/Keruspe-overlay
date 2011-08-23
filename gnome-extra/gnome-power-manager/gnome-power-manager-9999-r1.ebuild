# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"

inherit eutils gnome2-live virtualx

DESCRIPTION="Gnome Power Manager"
HOMEPAGE="http://www.gnome.org/projects/gnome-power-manager/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc test"

# FIXME: Interactive testsuite (upstream ? I'm so...pessimistic)
RESTRICT="test"

# Latest libcanberra is needed due to gtk+:3 API changes
COMMON_DEPEND=">=dev-libs/glib-2.25.9
	>=x11-libs/gtk+-2.91.7:3
	>=gnome-base/gnome-keyring-0.6.0
	>=x11-libs/libnotify-0.7.0
	>=x11-libs/cairo-1.0.0
	>=sys-power/upower-0.9.1
	>=x11-apps/xrandr-1.3
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender"
RDEPEND="${COMMON_DEPEND}
	>=sys-auth/consolekit-0.4[policykit]
	sys-auth/polkit
	gnome-extra/polkit-gnome"
DEPEND="${COMMON_DEPEND}
	x11-proto/randrproto
	x11-proto/xproto

	sys-devel/gettext
	app-text/scrollkeeper
	app-text/docbook-xml-dtd:4.3
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	>=app-text/gnome-doc-utils-0.3.2
	doc? (
		app-text/xmlto
		app-text/docbook-sgml-utils
		app-text/docbook-xml-dtd:4.4
		app-text/docbook-sgml-dtd:4.1
		app-text/docbook-xml-dtd:4.1.2 )
	test? ( sys-apps/dbus )"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable test tests)
		$(use_enable doc docbook-docs)
		--disable-strict
		--enable-compile-warnings=minimum
		--disable-schemas-compile"
	DOCS="AUTHORS ChangeLog NEWS README"

	if ! use doc; then
		G2CONF="${G2CONF} DOCBOOK2MAN=$(type -p false)"
	fi
}

src_prepare() {
	gnome2_src_prepare

	# Drop debugger CFLAGS from configure
	# XXX: touch configure.ac only if running eautoreconf, otherwise
	# maintainer mode gets triggered -- even if the order is correct
	sed -e 's:^CPPFLAGS="$CPPFLAGS -g"$::g' \
		-i configure || die "debugger sed failed"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "Test phase failed"
}
