# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit base

DESCRIPTION="A library that implements the DMAP family of protocols"
HOMEPAGE="http://www.flyn.org/projects/libdmapsharing"
SRC_URI="http://www.flyn.org/projects/${PN}/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/pkgconfig
	dev-libs/glib:2
	>=net-dns/avahi-0.6
	net-libs/libsoup
	media-libs/gstreamer
	media-libs/gst-plugins-base
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_configure() {
	econf --with-mdns=avahi
}
