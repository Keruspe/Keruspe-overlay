# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit mercurial

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
	>=dev-libs/libgee-0.5.0
	dev-libs/glib:2
	x11-libs/libnotify
	net-libs/libsoup:2.4
	dev-libs/libxml2
	>=net-libs/webkit-gtk-1.1
	dev-libs/libunique
	app-text/gtkspell
	indicate? ( >=dev-libs/libindicate-0.3 )"
DEPEND="${RDEPEND}
	>=dev-lang/vala-0.8.0
	sys-devel/gettext
	dev-util/intltool
	dev-lang/python"

src_configure() {
	local myconf=""
	use debug && myconf="--debug"

	if ! use indicate ; then
		# sabotage the detection since no configure option
		sed -i \
			-e 's|indicate|indicate-false|' \
			wscript || die "sed failed"
	fi

	./waf configure ${myconf} --prefix=/usr || die "configure failed"
}

src_compile() {
	./waf build || die "building failed"
}

src_install() {
	./waf --destdir="${D}" install || die "install failed"

	doicon img/pino.svg

	rm -rf "${D}/usr/share/doc"
	dodoc AUTHORS README
}
