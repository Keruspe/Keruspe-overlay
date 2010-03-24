# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Support library to communicate with Apple iPhone/iPod Touch devices"
HOMEPAGE="http://matt.colyer.name/projects/iphone-linux/index.php?title=Main_Page"
SRC_URI="http://cloud.github.com/downloads/MattColyer/libiphone/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python"

DEPEND="dev-util/pkgconfig
	${RDEPEND}"
RDEPEND=">=app-pda/libplist-1.1
	>=app-pda/usbmuxd-1.0.0_rc2
	>=dev-libs/glib-2.14.1
	dev-libs/libgcrypt
	net-libs/gnutls
	sys-fs/fuse
	virtual/libusb:0
	!app-pda/libiphone"

src_configure() {
	econf $(use_with python swig)
}

src_install() {
	make DESTDIR="${D}" install || die
}
