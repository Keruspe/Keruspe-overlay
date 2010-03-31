# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit mount-boot eutils flag-o-matic toolchain-funcs

SRC_URI="ftp://alpha.gnu.org/gnu/${PN}/${P}.tar.gz
	mirror://gentoo/${P}.tar.gz"

DESCRIPTION="GNU GRUB 2 boot loader"
HOMEPAGE="http://www.gnu.org/software/grub/"

LICENSE="GPL-3"
use multislot && SLOT="2" || SLOT="0"
KEYWORDS="~amd64"
IUSE="custom-cflags debug efi multislot static truetype"

RDEPEND=">=sys-libs/ncurses-5.2-r5
	dev-libs/lzo
	truetype? ( media-libs/freetype )"
DEPEND="${RDEPEND}
	dev-lang/ruby"
PROVIDE="virtual/bootloader"

export STRIP_MASK="*/grub/*/*.mod"
QA_EXECSTACK="sbin/grub-probe sbin/grub-setup sbin/grub-mkdevicemap"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.96-genkernel.patch
	epatch_user
}

src_configure() {
	use custom-cflags || unset CFLAGS CPPFLAGS LDFLAGS
	use static && append-ldflags -static

	local myconf=''
	use efi && myconf='--with-platform=efi'

	econf \
		--disable-werror \
		--sbindir=/sbin \
		--bindir=/bin \
		--libdir=/$(get_libdir) \
		--disable-efiemu \
		$(use_enable truetype grub-mkfont) \
		$(use_enable debug mm-debug) \
		$(use_enable debug grub-emu-usb) \
		$(use_enable debug grub-fstest) \
		${myconf}
}

src_compile() {
	emake -j1 || die "making regular stuff"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
	cat <<-EOF >> "${D}"/lib*/grub/grub-mkconfig_lib
	GRUB_DISTRIBUTOR="Gentoo"
	EOF
	if use multislot ; then
		sed -i "s:grub-install:grub2-install:" "${D}"/sbin/grub-install || die
		mv "${D}"/sbin/grub{,2}-install || die
		mv "${D}"/usr/share/info/grub{,2}.info || die
	fi
}

setup_boot_dir() {
	local boot_dir=$1
	local dir=${boot_dir}/grub

	if [[ ! -e ${dir}/grub.cfg ]] ; then
		einfo "Running: grub-mkconfig -o '${dir}/grub.cfg'"
		grub-mkconfig -o "${dir}/grub.cfg"
	fi
}

pkg_postinst() {
	if use multislot ; then
		elog "You have installed grub2 with USE=multislot, so to coexist"
		elog "with grub1, the grub2 install binary is named grub2-install."
	fi
	setup_boot_dir "${ROOT}"boot
}