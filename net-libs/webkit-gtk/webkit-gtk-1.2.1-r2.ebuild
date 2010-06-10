# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools

MY_P="webkit-${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="http://www.webkitgtk.org/"
SRC_URI="http://www.webkitgtk.org/${MY_P}.tar.gz"

LICENSE="LGPL-2 LGPL-2.1 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="coverage debug doc geoclue +gstreamer introspection pango"

RDEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
	media-libs/jpeg
	media-libs/libpng
	x11-libs/cairo

	>=x11-libs/gtk+-2.10
	>=dev-libs/icu-3.8.1-r1
	>=net-libs/libsoup-2.29.90
	>=dev-db/sqlite-3
	>=app-text/enchant-0.22

	geoclue? ( gnome-extra/geoclue )

	gstreamer? (
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-base:0.10 )
	introspection? (
		>=dev-libs/gobject-introspection-0.6.2
		>=net-libs/libsoup-2.31[introspection]
		!!dev-libs/gir-repository[webkit] )
	pango? ( >=x11-libs/pango-1.12 )
	!pango? (
		media-libs/freetype:2
		media-libs/fontconfig )
"

DEPEND="${RDEPEND}
	>=sys-devel/flex-2.5.33
	sys-devel/gettext
	dev-util/gperf
	dev-util/pkgconfig
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.10 )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	rm -v autotools/lt* autotools/libtool.m4 \
		|| die "removing libtool macros failed"
	sed -i 's/-O2//g' "${S}"/configure.ac || die "sed failed"
	epatch ${FILESDIR}/webkit-icu-4.4.patch
	AT_M4DIR=autotools eautoreconf
}

src_configure() {
	use alpha && append-ldflags "-Wl,--no-relax"

	local myconf

	myconf="
		$(use_enable coverage)
		$(use_enable debug)
		$(use_enable geoclue geolocation)
		$(use_enable gstreamer video)
		$(use_enable introspection)
		"

	if use pango; then
		ewarn "You have enabled the incomplete pango backend"
		ewarn "Please file any and all bugs *upstream*"
		myconf="${myconf} --with-font-backend=pango"
	else
		myconf="${myconf} --with-font-backend=freetype"
	fi

	econf ${myconf}
}

src_compile() {
	addpredict "$(unset HOME; echo ~)/.local"
	emake || die "Compile failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc WebKit/gtk/{NEWS,ChangeLog} || die "dodoc failed"
}
