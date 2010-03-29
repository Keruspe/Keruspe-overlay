# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils gnome2 virtualx

DESCRIPTION="Gnome Power Manager"
HOMEPAGE="http://www.gnome.org/projects/gnome-power-manager/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="applets doc policykit test"

COMMON_DEPEND=">=dev-libs/glib-2.6.0
	>=x11-libs/gtk+-2.17.7
	>=gnome-base/gconf-2.10.0
	>=gnome-base/gnome-keyring-0.6.0
	>=dev-libs/dbus-glib-0.71
	>=x11-libs/libnotify-0.4.3
	>=x11-libs/libwnck-2.10.0
	>=x11-libs/cairo-1.0.0
	applets? ( >=gnome-base/gnome-panel-2 )
	>=gnome-base/gconf-2.10
	>=media-libs/libcanberra-0.10[gtk]
	|| ( sys-apps/upower >=sys-apps/devicekit-power-008 )
	>=dev-libs/libunique-1
	>=x11-apps/xrandr-1.2
	x11-libs/libX11
	x11-libs/libXext
"
RDEPEND="${COMMON_DEPEND}
	>=sys-auth/consolekit-0.4[policykit?]
	policykit? ( gnome-extra/polkit-gnome )
"
DEPEND="${COMMON_DEPEND}
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
		app-text/docbook-xml-dtd:4.1.2 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable test tests)
		$(use_enable doc docbook-docs)
		$(use_enable policykit gconf-defaults)
		$(use_enable applets)
		--enable-compile-warnings=minimum
		--with-dpms-ext"
}

src_prepare() {
	gnome2_src_prepare
	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf

	if ! use doc; then
		sed -e 's:@HAVE_DOCBOOK2MAN_TRUE@.*::' \
			-i "${S}/man/Makefile.in" || die "sed 4 failed"
	fi

	use elibc_glibc || sed -e 's/-lresolv//' -i configure || die "sed 5 failed"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "Test phase failed"
}

