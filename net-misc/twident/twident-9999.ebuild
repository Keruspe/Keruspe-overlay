# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit cmake-utils git

DESCRIPTION="Twitter and Identi.ca client"
HOMEPAGE="http://github.com/Keruspe/Twident"
SRC_URI=""
EGIT_REPO_URI="git://github.com/Keruspe/Twident"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug indicate"

RDEPEND="x11-libs/gtk+:2
	dev-libs/libgee
	net-libs/rest
	x11-libs/libnotify
	net-libs/libsoup:2.4
	dev-libs/libxml2
	app-text/gtkspell
	indicate? ( dev-libs/libindicate )"
DEPEND="${RDEPEND}
	>=dev-lang/vala-0.11.4:0.12
	sys-devel/gettext
	dev-util/intltool"

src_configure() {
	mycmakeargs=(
		-DUBUNTU_ICONS=OFF
		$(cmake-utils_use debug ENABLE_DEBUG)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	doicon img/twident.svg

	rm -rf "${D}/usr/share/doc"
	dodoc AUTHORS README
}
