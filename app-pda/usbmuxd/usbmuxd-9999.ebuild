# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils git

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="http://marcansoft.com/blog/iphonelinux/usbmuxd/"
EGIT_REPO_URI="git://git.marcansoft.com/usbmuxd.git"
SRC_URI=""

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
}

src_install() {
	cmake-utils_src_install
	dodoc README
	doinitd ${FILESDIR}/usbmuxd
}
