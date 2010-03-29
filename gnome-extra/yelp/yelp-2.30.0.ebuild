# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils gnome2

DESCRIPTION="Help browser for GNOME"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="beagle lzma"

RDEPEND=">=gnome-base/gconf-2
	>=app-text/gnome-doc-utils-0.19.1
	>=x11-libs/gtk+-2.18
	>=dev-libs/glib-2.16
	>=dev-libs/libxml2-2.6.5
	>=dev-libs/libxslt-1.1.4
	>=x11-libs/startup-notification-0.8
	>=dev-libs/dbus-glib-0.71
	beagle? ( || (
		>=dev-libs/libbeagle-0.3.0
		=app-misc/beagle-0.2* ) )
	net-libs/xulrunner:1.9
	sys-libs/zlib
	app-arch/bzip2
	lzma? ( || (
		app-arch/xz-utils
		app-arch/lzma-utils ) )
	>=app-text/rarian-0.7"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	gnome-base/gnome-common"

DOCS="AUTHORS ChangeLog NEWS README TODO"

G2CONF="${G2CONF}
	--with-gecko=libxul-embedding
	$(use_enable lzma)"

if use beagle; then
	G2CONF="${G2CONF} --with-search=beagle"
else
	G2CONF="${G2CONF} --with-search=basic"
fi

src_prepare() {
	gnome2_src_prepare
	epatch "${FILESDIR}/${PN}-2.26.0-automagic-lzma.patch"
	epatch "${FILESDIR}/${PN}-2.28.1-system-nspr.patch"
	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
	sed -i 's|$AM_CFLAGS -pedantic -ansi|$AM_CFLAGS|' configure || die "sed	failed"
}
