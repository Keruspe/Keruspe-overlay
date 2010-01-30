# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="A modular geoinformation service built on top of the D-Bus messaging system"
HOMEPAGE="http://freedesktop.org/wiki/Software/GeoClue"
SRC_URI="http://folks.o-hand.com/jku/geoclue-releases/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="dbus doc gpsd gtk networkmanager"

RDEPEND=">=dev-libs/glib-2
        >=gnome-base/gconf-2
        >=dev-libs/dbus-glib-0.60
        dev-libs/libxml2
	gpsd? ( sci-geosciences/gpsd )
        gtk? ( >=x11-libs/gtk+-2 )
	networkmanager? ( net-misc/networkmanager )"
DEPEND="${RDEPEND}
        dev-util/pkgconfig
        dev-libs/libxslt
        doc? ( >=dev-util/gtk-doc-1 )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/0001-Remove-automagic-deps-and-add-switches-to-enable-dis.patch"
	epatch "${FILESDIR}/0002-Fix-NM-pkgcheck.patch"

	eautoreconf
}

src_compile() {
	LDFLAGS=""
	econf --disable-conic --disable-gypsy --disable-gsmloc \
		$(use_enable gpsd) \
		$(use_enable gtk) \
		$(use_enable networkmanager) || die "econf failed"
	emake || die "Make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README || die "dodoc failed"
}
