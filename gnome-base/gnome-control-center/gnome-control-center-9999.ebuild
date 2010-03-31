# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils git gnome2

DESCRIPTION="The gnome2 Desktop configuration tool"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2"

SRC_URI=""
EGIT_REPO_URI="git://git.gnome.org/gnome-control-center"

SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="eds mutter policykit"

RDEPEND="x11-libs/libXft
	>=x11-libs/libXi-1.2
	>=x11-libs/gtk+-2.15.0
	>=dev-libs/glib-2.17.4
	>=gnome-base/gconf-2.0
	>=gnome-base/librsvg-2.0
	>=gnome-base/nautilus-2.6
	>=media-libs/fontconfig-1
	>=dev-libs/dbus-glib-0.73
	>=x11-libs/libxklavier-4.0
	!mutter? ( >=x11-wm/metacity-2.23.1 )
	mutter? ( x11-wm/mutter )
	>=gnome-base/libgnomekbd-2.27.4
	>=gnome-base/gnome-desktop-2.27.90
	>=gnome-base/gnome-menus-2.11.1
	gnome-base/gnome-settings-daemon

	dev-libs/libunique
	x11-libs/pango
	dev-libs/libxml2
	media-libs/freetype
	>=media-libs/libcanberra-0.4[gtk]

	eds? ( >=gnome-extra/evolution-data-server-1.7.90 )
	policykit? ( >=gnome-base/gconf-2.28[policykit] )

	x11-apps/xmodmap
	x11-libs/libXScrnSaver
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXxf86misc
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXcursor"
DEPEND="${RDEPEND}
	x11-proto/scrnsaverproto
	x11-proto/xextproto
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto
	x11-proto/randrproto
	x11-proto/renderproto

	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.19
	dev-util/desktop-file-utils

	>=app-text/gnome-doc-utils-0.10.1"

DOCS="AUTHORS ChangeLog NEWS README TODO"

if use mutter; then
	wm=mutter
else
	wm=metacity
fi

G2CONF="${G2CONF}
	--disable-update-mimedb
	--disable-static
	$(use_enable eds aboutme)
	--with-window-manager=${wm}"


src_unpack() {
	git_src_unpack
	cd ${S}
	git checkout extensible-shell
}

src_prepare() {
	gnome2_src_prepare
	mkdir m4
	intltoolize --force --copy --automake
	gnome-doc-prepare --force --copy --automake
	eautoreconf
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}
