# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit bash-completion gnome2

DESCRIPTION="Daemon providing interfaces to work with storage devices"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/DeviceKit"
SRC_URI="http://hal.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc lvm"

RDEPEND=">=dev-libs/glib-2.16.1
	>=dev-libs/dbus-glib-0.82
	>=sys-apps/dbus-1.0
	>=sys-auth/polkit-0.92
	>=sys-fs/udev-147[extras]
	>=sys-apps/parted-1.8.8[device-mapper]
	>=dev-libs/libatasmart-0.14
	>=sys-apps/sg3_utils-1.27.20090411
	lvm? ( >=sys-fs/lvm2-2.02.61 )
	dev-db/sqlite:3"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	!sys-apps/devicekit-disks
	dev-libs/libxslt"

G2CONF="${G2CONF}
	--localstatedir=/var
	--enable-man-pages
	$(use_enable lvm lvm2)
	$(use_enable lvm dmmp)
	$(use_enable debug verbose-mode)"

src_install() {
	gnome2_src_install

	if use bash-completion; then
		dobashcompletion "${S}/tools/udisks-bash-completion.sh"
	fi
}
