# Copyright 1999-2010 Gentoo Foundation
# Copyright 2009-2010 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Gnome Partition Editor"
HOMEPAGE="http://gparted.sourceforge.net/"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="dmraid fat hfs jfs kde ntfs reiserfs reiser4 xfs"

common_depends=">=sys-apps/parted-1.7.1
	>=dev-cpp/gtkmm-2.8.0"

RDEPEND="${common_depends}
	kde? ( || ( kde-base/kdesu kde-base/kdebase ) )

	>=sys-fs/e2fsprogs-1.41.0
	dmraid? ( || (
			>=sys-fs/lvm2-2.02.45
			sys-fs/device-mapper )
		sys-fs/dmraid
		sys-fs/multipath-tools )
	fat? ( sys-fs/dosfstools )
	ntfs? ( sys-fs/ntfsprogs )
	hfs? (
		sys-fs/udev
		sys-fs/hfsutils )
	jfs? ( sys-fs/jfsutils )
	reiserfs? ( sys-fs/reiserfsprogs )
	reiser4? ( sys-fs/reiser4progs )
	xfs? ( sys-fs/xfsprogs sys-fs/xfsdump )"

DEPEND="${common_depends}
	>=dev-util/pkgconfig-0.12
	>=dev-util/intltool-0.35.5
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	app-text/docbook-xml-dtd:4.1.2"

DOCS="AUTHORS NEWS ChangeLog README"

src_unpack() {
	gnome2_src_unpack

	# Revert upstream changes to use gksu inconditionally
	sed "s:Exec=@gksuprog@ :Exec=:" \
		-i gparted.desktop.in.in || die "sed 1 failed"
}

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-doc
		--disable-scrollkeeper
		GKSUPROG=$(type -P true)"
}

src_install() {
	gnome2_src_install

	if use kde; then
		cp "${D}"/usr/share/applications/gparted.desktop \
			"${D}"/usr/share/applications/gparted-kde.desktop

		sed -i "s:Exec=:Exec=kdesu :" "${D}"/usr/share/applications/gparted-kde.desktop
		echo "OnlyShowIn=KDE;" >> "${D}"/usr/share/applications/gparted-kde.desktop
	fi
}
