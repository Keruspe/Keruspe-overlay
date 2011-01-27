# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit cmake-utils mercurial

DESCRIPTION="Twitter and Identi.ca client"
HOMEPAGE="http://pino-app.appspot.com/"
SRC_URI=""
EHG_REPO_URI="http://bitbucket.org/troorl/pino3"
S="${WORKDIR}/pino3"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug indicate"

RDEPEND="x11-libs/gtk+:2
	>=sys-devel/gcc-4.2
	>=dev-libs/libgee-0.5.0
	net-libs/librest
	x11-libs/libnotify
	net-libs/libsoup:2.4
	dev-libs/libxml2
	>=dev-libs/libunique-1.0:0
	app-text/gtkspell
	indicate? ( dev-libs/libindicate )"
DEPEND="${RDEPEND}
	>=dev-lang/vala-0.10:0.10
	sys-devel/gettext
	dev-util/intltool"

src_prepare() {
	sed -i '/webkit/d' CMakeLists.txt
	sed -i '/get_style_property/d' src/visual_style.vala
}

src_configure() {
	sed -i 's/valac/valac-0.10/g' cmake/FindVala.cmake
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
