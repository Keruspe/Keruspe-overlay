# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2:2.5"
inherit autotools base python eutils git-2

DESCRIPTION="A link-local XMPP connection manager for Telepathy"
HOMEPAGE="http://telepathy.freedesktop.org/wiki/Components"
SRC_URI=""
EGIT_HAS_SUBMODULES="yes"
EGIT_REPO_URI="git://anongit.freedesktop.org/telepathy/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-libs/libxml2
	>=dev-libs/glib-2.24:2
	>=sys-apps/dbus-1.1.0
	>=net-libs/telepathy-glib-0.14
	>=net-dns/avahi-0.6.22
	net-libs/libsoup:2.4
	sys-apps/util-linux"
DEPEND="${RDEPEND}
	app-text/xmldiff
	test? (
		>=dev-libs/check-0.9.4
		net-libs/libgsasl
		dev-python/twisted-words )
	dev-libs/libxslt
	dev-util/gtk-doc
	dev-util/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	python_set_active_version 2
}

src_prepare() {
	cd lib/ext/wocky
	gtkdocize
	eautoreconf
	cd ../../..
	eautoreconf
	python_convert_shebangs -r 2 .
}

src_configure() {
	econf \
		--disable-Werror
}
