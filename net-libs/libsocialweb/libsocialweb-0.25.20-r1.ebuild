# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2"

inherit gnome2 python

DESCRIPTION="Social web services integration framework"
HOMEPAGE="http://git.gnome.org/browse/libsocialweb"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc connman +gnome +introspection +networkmanager vala"

# NOTE: coverage testing should not be enabled
RDEPEND=">=dev-libs/glib-2.14:2
	>=net-libs/rest-0.7.10

	gnome-base/gconf:2
	gnome-base/libgnome-keyring
	dev-libs/dbus-glib
	dev-libs/json-glib
	net-libs/libsoup:2.4

	gnome? ( >=net-libs/libsoup-gnome-2.25.1:2.4 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )
	networkmanager? ( net-misc/networkmanager )
	!networkmanager? ( connman? ( net-misc/connman ) )"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.15
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	sys-devel/gettext
	doc? (
		dev-libs/libxslt
		>=dev-util/gtk-doc-1.15 )
	vala? (
		dev-lang/vala:0.14[vapigen]
		>=dev-libs/gobject-introspection-0.9.6 )"

# Introspection is needed for vala bindings
REQUIRED_USE="vala? ( introspection )"

pkg_setup() {
	# TODO: enable sys-apps/keyutils support (--without-kernel-keyring)
	G2CONF="${G2CONF}
		--disable-static
		--disable-gcov
		--without-kernel-keyring
		--enable-all-services
		$(use_enable introspection)
		$(use_enable vala vala-bindings)
		$(use_with gnome)
		VALAC=$(type -P valac-0.14)
		VAPIGEN=$(type -P vapigen-0.14)
		--with-online=always"

	# NetworkManager always overrides connman support
	use connman && G2CONF="${G2CONF} --with-online=connman"
	use networkmanager && G2CONF="${G2CONF} --with-online=networkmanager"

	DOCS="AUTHORS README TODO"

	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	gnome2_src_prepare

	python_convert_shebangs 2 "${S}/tools/glib-ginterface-gen.py"
}
