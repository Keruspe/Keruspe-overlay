# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit base

DESCRIPTION="System service to accurately color manage input and output devices"
HOMEPAGE="http://colord.hughsie.com/"
SRC_URI="http://people.freedesktop.org/~hughsient/releases/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="scanner +udev"

# XXX: raise to libusb-1.0.9:1 when available
RDEPEND="
	dev-db/sqlite:3
	>=dev-libs/glib-2.28.0:2
	>=dev-libs/libusb-1.0.8:1
	>=media-libs/lcms-2.2:2
	>=sys-auth/polkit-0.97
	scanner? ( media-gfx/sane-backends )
	udev? ( || ( sys-fs/udev[gudev] sys-fs/udev[extras] ) )
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	dev-util/pkgconfig
	>=sys-devel/gettext-0.17
"

RESTRICT="test"

DOCS=(AUTHORS ChangeLog MAINTAINERS NEWS README TODO)

src_configure() {
	econf \
		--disable-examples \
		--disable-static \
		--enable-polkit \
		--enable-reverse \
		$(use_enable scanner sane) \
		$(use_enable udev gudev)
}

src_install() {
	base_src_install
	find "${D}" -name "*.la" -delete
}
