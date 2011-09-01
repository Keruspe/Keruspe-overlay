# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit autotools git-2

DESCRIPTION="Pulseaudio Volume Control, GTK based mixer for Pulseaudio"
HOMEPAGE="http://0pointer.de/lennart/projects/pavucontrol/"
SRC_URI=""
EGIT_REPO_URI="git://git.0pointer.de/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gtk3 nls"

RDEPEND="gtk3? ( >=dev-cpp/gtkmm-2.98:3.0 )
	!gtk3? ( >=dev-cpp/gtkmm-2.16:2.4
		dev-cpp/libglademm:2.4 )
	>=dev-libs/libsigc++-2.2:2
	>=media-sound/pulseaudio-0.9.16[glib]
	>=media-libs/libcanberra-0.16[gtk,gtk3?]
	|| ( x11-themes/tango-icon-theme x11-themes/gnome-icon-theme )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext
		dev-util/intltool )
	dev-util/pkgconfig"

src_prepare() {
	touch doc/README
	intltoolize --copy --automake
	eautoreconf
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		--htmldir=/usr/share/doc/${PF}/html \
		--disable-dependency-tracking \
		--disable-lynx \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${ED}" install
}
