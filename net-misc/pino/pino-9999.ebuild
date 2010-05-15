# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils mercurial

DESCRIPTION="Twitter and Identi.ca client"
HOMEPAGE="http://pino-app.appspot.com/"
SRC_URI=""
EHG_REPO_URI="https://pino-twitter.googlecode.com/hg/"
S="${WORKDIR}/hg"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug indicate"

RDEPEND="x11-libs/gtk+:2
	>=sys-devel/gcc-4.2
	>=dev-libs/libgee-0.5.0
	x11-libs/libnotify
	net-libs/libsoup:2.4
	dev-libs/libxml2
	>=net-libs/webkit-gtk-1.0
	>=dev-libs/libunique-1.0
	app-text/gtkspell
	indicate? ( dev-libs/libindicate )"
DEPEND="${RDEPEND}
	>=dev-lang/vala-0.7.10
	sys-devel/gettext
	dev-util/intltool
	dev-lang/python"

src_configure() {
	mycmakeargs=(
		-DUBUNTU_ICONS=OFF
		$(cmake-utils_use debug ENABLE_DEBUG)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	doicon img/pino.svg

	rm -rf "${D}/usr/share/doc"
	dodoc AUTHORS README
}
