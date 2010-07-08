# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
EGIT_REPO_URI="git://anongit.freedesktop.org/git/cairo"

inherit eutils flag-o-matic autotools git

DESCRIPTION="A vector graphics library with cross-device output support"
HOMEPAGE="http://cairographics.org/"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aqua debug directfb doc glitz opengl +svg X xcb"

RESTRICT="test"

RDEPEND="media-libs/fontconfig
	>=media-libs/freetype-2.1.9
	sys-libs/zlib
	media-libs/libpng:0
	>=x11-libs/pixman-0.12.0
	directfb? ( >=dev-libs/DirectFB-0.9.24 )
	glitz? ( >=media-libs/glitz-0.5.1 )
	svg? ( dev-libs/libxml2 )
	X? (
		>=x11-libs/libXrender-0.6
		x11-libs/libXext
		x11-libs/libX11
		x11-libs/libXft
	)
	xcb? (
		>=x11-libs/libxcb-0.92
		x11-libs/xcb-util
	)"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19
	>=sys-devel/libtool-2
	doc? (
		>=dev-util/gtk-doc-1.6
		~app-text/docbook-xml-dtd-4.2
	)
	X? ( x11-proto/renderproto )"

WANT_AUTOMAKE=1.11

src_prepare() {
	epatch 	"${FILESDIR}"/${P}-libpng14.patch

	touch boilerplate/Makefile.am.features
	touch src/Makefile.am.features
	touch ChangeLog

	eautoreconf
	cp -a build/* .
}

src_configure() {
	append-flags -finline-limit=1200

	if use glitz && use opengl; then
		export glitz_LIBS=$(pkg-config --libs glitz-glx)
	fi

	econf \
		$(use_enable X xlib) \
		$(use_enable X xlib-xrender) \
		$(use_enable aqua quartz) \
		$(use_enable aqua quartz-image) \
		$(use_enable debug test-surfaces) \
		$(use_enable directfb) \
		$(use_enable doc gtk-doc) \
		$(use_enable glitz) \
		$(use_enable xcb) \
		$(use_enable svg) \
		--enable-pdf \
		--enable-png \
		--enable-ft \
		--enable-ps
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"
	dodoc AUTHORS ChangeLog NEWS README || die
}

pkg_postinst() {
	if use xcb; then
		ewarn "You have enabled the Cairo XCB backend which is used only by"
		ewarn "a select few apps. The Cairo XCB backend is presently"
		ewarn "un-maintained and needs a lot of work to get it caught up"
		ewarn "to the Xrender and Xlib backends, which are the backends used"
		ewarn "by most applications. See:"
		ewarn "http://lists.freedesktop.org/archives/xcb/2008-December/004139.html"
	fi
}
