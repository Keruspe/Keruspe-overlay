# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
GCONF_DEBUG="no"
inherit gnome2

DESCRIPTION="Multimedia tools for the GNOME desktop"
HOMEPAGE="http://live.gnome.org/GnomeMedia"

LICENSE="LGPL-2 GPL-2 FDL-1.1"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND=">=dev-libs/glib-2.18.2:2
	>=x11-libs/gtk+-2.91.0:3
	>=gnome-base/gconf-2.6.1
	>=media-libs/gstreamer-0.10.23
	>=media-libs/gst-plugins-base-0.10.23
	>=media-libs/gst-plugins-good-0.10
	dev-libs/libxml2

	>=media-libs/libcanberra-0.13[gtk3]
	media-libs/libgnome-media-profiles:3
	>=media-libs/gst-plugins-base-0.10.23:0.10
	>=media-plugins/gst-plugins-meta-0.10-r2:0.10
	>=media-plugins/gst-plugins-gconf-0.10.23"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=app-text/scrollkeeper-0.3.11
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	!gnome-extra/gnome-media:2"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-static
		--disable-scrollkeeper
		--disable-schemas-install
		--enable-gstprops
		--enable-grecord
		--disable-gstmix"
	DOCS="AUTHORS ChangeLog* NEWS MAINTAINERS README"
}

src_install() {
	gnome2_src_install
	rm -v "${ED}"/usr/share/sounds/gnome/default/alerts/*.ogg || die
}

pkg_postinst() {
	gnome2_pkg_postinst
	ewarn
	ewarn "If you cannot play some music format, please check your"
	ewarn "USE flags on media-plugins/gst-plugins-meta"
	ewarn
}
