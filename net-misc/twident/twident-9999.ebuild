# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
WANT_AUTOMAKE=1.11
inherit autotools git-2

DESCRIPTION="Twitter and Identi.ca client"
HOMEPAGE="http://github.com/Keruspe/Twident"
SRC_URI=""
EGIT_REPO_URI="git://github.com/Keruspe/Twident"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""

RDEPEND=">=x11-libs/gtk+-2.24:2
	>=dev-libs/glib-2.14:2
	>=dev-libs/libgee-0.5
	>=x11-libs/libnotify-0.7
	net-libs/libsoup:2.4
	dev-libs/libxml2
	>=net-libs/rest-0.7.10"
DEPEND="${RDEPEND}
	>=dev-lang/vala-0.11.4:0.12
	sys-devel/gettext
	dev-util/intltool"

src_prepare() {
	mkdir m4
	eautoreconf
}

src_install() {
	emake DESTDIR="${ED}" install
	doicon img/twident.svg
}
