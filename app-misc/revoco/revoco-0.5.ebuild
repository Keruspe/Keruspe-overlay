# Copyright 1999-2010 Gentoo Foundation
# Copyright 2009-2010 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs linux-info

DESCRIPTION="Tool for controlling Logitech MX Revolution mouses"
HOMEPAGE="http://goron.de/~froese/"
SRC_URI="http://goron.de/~froese/revoco/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=sys-fs/udev-145"

CONFIG_CHECK="USB_HIDDEV"
ERROR_USB_HIDDEN="You need to the CONFIG_USB_HIDDEV option turned on."

src_prepare() {
	epatch "${FILESDIR}/cleanup-${PV}.patch" || die "patch failed"
}

src_compile() {
	$(tc-getCC) -DVERSION=${PV} ${CFLAGS} ${LDFLAGS} \
	${PN}.c -o ${PN} || die "Failed to compile ${PN}"
}

src_install() {
	dobin ${PN} || die "dobin failed"
}

pkg_postinst() {
	elog "Your user needs to be in the usb group to use revoco."
}

