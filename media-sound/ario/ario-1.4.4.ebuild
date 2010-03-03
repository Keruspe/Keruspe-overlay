# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2-utils

DESCRIPTION="a GTK2 MPD (Music Player Daemon) client inspired by Rythmbox"
HOMEPAGE="http://ario-player.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}-player/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="audioscrobbler dbus debug idle libnotify nls python taglib zeroconf"

RDEPEND=">=dev-libs/glib-2.14:2
	dev-libs/libunique
	media-libs/libmpdclient
	net-misc/curl
	net-libs/gnutls
	>=x11-libs/gtk+-2.16:2
	audioscrobbler? ( net-libs/libsoup:2.4 )
	dbus? ( dev-libs/dbus-glib )
	libnotify? ( x11-libs/libnotify )
	python? ( dev-python/pygtk
		dev-python/pygobject )
	taglib? ( media-libs/taglib )
	zeroconf? ( net-dns/avahi )"
DEPEND="sys-devel/gettext
	dev-util/intltool
	dev-util/pkgconfig"

src_configure() {
	econf \
		--enable-libmpdclient2 \
		--enable-search \
		--enable-playlists \
		$(use_enable audioscrobbler) \
		$(use_enable dbus) \
		$(use_enable debug) \
		$(use_enable idle mpdidle) \
		$(use_enable libnotify notify) \
		$(use_enable nls) \
		$(use_enable python) \
		$(use_enable taglib) \
		$(use_enable zeroconf avahi)
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
