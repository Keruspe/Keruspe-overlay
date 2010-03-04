# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit mercurial

DESCRIPTION="A lightweight microblogging client for Gnome"
HOMEPAGE="http://pino-app.appspot.com/"
SRC_URI=""
EHG_REPO_URI="https://pino-twitter.googlecode.com/hg/"
S="${WORKDIR}/hg"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/vala-0.7.10
	>=sys-devel/gcc-4.2
	dev-util/intltool
	sys-devel/gettext
	>=x11-libs/gtk+-2.0
	>=dev-libs/libgee-0.5.0
	>=dev-libs/glib-2.0
	x11-libs/libnotify
	>=net-libs/libsoup-2.4
	dev-libs/libxml2
	>=net-libs/webkit-gtk-1.0"
RDEPEND="${DEPEND}"

src_unpack() {
	mercurial_src_unpack
}

src_configure() {
	./waf configure --prefix=/usr
}

src_compile() {
	./waf build
}

src_install() {
	./waf --destdir="${D}" install
}
