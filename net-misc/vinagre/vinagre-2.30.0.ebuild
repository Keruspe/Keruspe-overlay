# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils gnome2

DESCRIPTION="VNC Client for the GNOME Desktop"
HOMEPAGE="http://www.gnome.org/projects/vinagre/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="applet avahi +ssh +telepathy test"

RDEPEND=">=dev-libs/glib-2.17.0
	>=x11-libs/gtk+-2.16
	>=gnome-base/gconf-2.16
	>=net-libs/gtk-vnc-0.3.9
	>=gnome-base/gnome-keyring-1
	applet? ( >=gnome-base/gnome-panel-2 )
	avahi? (
		>=dev-libs/libxml2-2.6.31
		>=net-dns/avahi-0.6.22[dbus,gtk] )
	ssh? (
		>=dev-libs/libxml2-2.6.31
		>=x11-libs/vte-0.20 )
	telepathy? ( >=net-libs/telepathy-glib-0.7.31 )"

DEPEND="${RDEPEND}
	gnome-base/gnome-common
	>=dev-lang/perl-5
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	test? ( ~app-text/docbook-xml-dtd-4.3 )"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

G2CONF="${G2CONF}
	--disable-scrollkeeper
	$(use_enable avahi)
	$(use_enable applet)
	$(use_enable ssh)
	$(use_enable telepathy)"

src_prepare() {
	gnome2_src_prepare

	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed failed"
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
	rm -rf "${D}"/usr/share/doc/vinagre
}
