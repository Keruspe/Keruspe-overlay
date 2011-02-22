# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils libtool multilib gnome.org

DESCRIPTION="High level XKB library"
HOMEPAGE="http://www.freedesktop.org/Software/LibXklavier"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="x11-misc/xkeyboard-config
	x11-libs/libX11
	>=x11-libs/libXi-1.1.3
	x11-apps/xkbcomp
	x11-libs/libxkbfile
	>=dev-libs/glib-2.16:2
	dev-libs/libxml2
	app-text/iso-codes"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext
	doc? ( >=dev-util/gtk-doc-1.4 )"

src_prepare() {
	elibtoolize
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-static \
		--with-html-dir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--with-xkb-base="${EPREFIX}/usr/share/X11/xkb" \
		--with-xkb-bin-base="${EPREFIX}/usr/bin" \
		$(use_enable doc gtk-doc)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog CREDITS NEWS README || die
}
