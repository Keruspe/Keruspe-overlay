# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit autotools eutils git

DESCRIPTION="Pulseaudio Volume Control, GTK based mixer for Pulseaudio"
HOMEPAGE="http://0pointer.de/lennart/projects/pavucontrol/"
SRC_URI=""
EGIT_REPO_URI="git://git.0pointer.de/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=dev-cpp/gtkmm-2.98:3.0
	>=dev-libs/libsigc++-2.2:2
	>=media-libs/libcanberra-0.16[gtk3]
	>=media-sound/pulseaudio-0.9.16[glib]
	|| ( x11-themes/tango-icon-theme x11-themes/gnome-icon-theme )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext
		dev-util/intltool )
	dev-util/pkgconfig"

src_prepare() {
	touch doc/README
	epatch ${FILESDIR}/0001-Port-to-gtkmm-3.0.patch
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
	emake DESTDIR="${ED}" install || die
}
