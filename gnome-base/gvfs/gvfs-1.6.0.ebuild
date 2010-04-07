# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools bash-completion gnome2 eutils

DESCRIPTION="GNOME Virtual Filesystem Layer"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="afc archive avahi bluetooth cdda doc fuse gdu gnome gnome-keyring gphoto2
+http samba +udev"

RDEPEND=">=dev-libs/glib-2.21.2
	>=sys-apps/dbus-1.0
	dev-libs/libxml2
	net-misc/openssh
	>=sys-fs/udev-145
	afc? ( app-pda/libimobiledevice )
	archive? ( app-arch/libarchive )
	avahi? ( >=net-dns/avahi-0.6 )
	bluetooth? (
		>=app-mobilephone/obex-data-server-0.4.5
		dev-libs/dbus-glib
		net-wireless/bluez
		dev-libs/expat )
	fuse? ( sys-fs/fuse )
	gdu? ( >=sys-apps/gnome-disk-utility-2.29 )
	gnome? ( >=gnome-base/gconf-2.0 )
	gnome-keyring? ( >=gnome-base/gnome-keyring-1.0 )
	gphoto2? ( >=media-libs/libgphoto2-2.4.7 )
	udev? (
		cdda? ( >=dev-libs/libcdio-0.78.2[-minimal] )
		>=sys-fs/udev-145[extras] )
	http? ( >=net-libs/libsoup-gnome-2.25.1 )
	samba? ( >=net-fs/samba-3.4[smbclient] )"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.19
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

if use cdda && ! use udev; then
	ewarn "You have \"+cdda\", but you have \"-udev\""
	ewarn "cdda support will NOT be built unless you enable udev"
fi

G2CONF="${G2CONF}
	--enable-udev
	--disable-bash-completion
	$(use_enable afc)
	$(use_enable archive)
	$(use_enable avahi)
	$(use_enable bluetooth obexftp)
	$(use_enable cdda)
	$(use_enable fuse)
	$(use_enable gdu)
	$(use_enable gnome gconf)
	$(use_enable gphoto2)
	$(use_enable udev gudev)
	--disable-hal
	$(use_enable http)
	$(use_enable gnome-keyring keyring)
	$(use_enable samba)"

src_prepare() {
	gnome2_src_prepare
	use gphoto2 && epatch "${FILESDIR}/${PN}-1.2.2-gphoto2-stricter-checks.patch"
	if use archive; then
		epatch "${FILESDIR}/${PN}-1.2.2-expose-archive-backend.patch"
		echo "mount-archive.desktop.in" >> po/POTFILES.in
		echo "mount-archive.desktop.in.in" >> po/POTFILES.in
	fi
	use gphoto2 || use archive && eautoreconf
}

src_install() {
	gnome2_src_install
	use bash-completion && \
		dobashcompletion programs/gvfs-bash-completion.sh ${PN}
}

pkg_postinst() {
	gnome2_pkg_postinst
	use bash-completion && bash-completion_pkg_postinst

	ewarn "In order to use the new gvfs services, please reload dbus configuration"
	ewarn "You may need to log out and log back in for some changes to take effect"
}
