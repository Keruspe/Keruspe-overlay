# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit autotools bash-completion gnome2 eutils

DESCRIPTION="GNOME Virtual Filesystem Layer"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
IUSE="archive avahi bluetooth cdda doc fuse gdu gnome-keyring gphoto2 hal +http
iphone samba +udev"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
DOCS="AUTHORS ChangeLog ChangeLog.pre-1-2 NEWS README TODO"

RDEPEND=">=dev-libs/glib-2.27.4
	>=sys-apps/dbus-1.0
	dev-libs/libxml2
	net-misc/openssh
	>=sys-fs/udev-138
	archive? ( app-arch/libarchive )
	avahi? ( >=net-dns/avahi-0.6 )
	bluetooth? (
		>=app-mobilephone/obex-data-server-0.4.5
		dev-libs/dbus-glib
		net-wireless/bluez
		dev-libs/expat )
	fuse? ( sys-fs/fuse )
	gdu? ( >=sys-apps/gnome-disk-utility-2.29 )
	gnome-keyring? ( >=gnome-base/gnome-keyring-1.0 )
	gphoto2? ( >=media-libs/libgphoto2-2.4.7 )
	iphone? (
		>=app-pda/libimobiledevice-1.1.0
		>=app-pda/libplist-0.15 )
	udev? (
		cdda? ( >=dev-libs/libcdio-0.78.2[-minimal] )
		>=sys-fs/udev-145[extras] )
	hal? (
		cdda? ( >=dev-libs/libcdio-0.78.2[-minimal] )
		>=sys-apps/hal-0.5.10 )
	http? ( >=net-libs/libsoup-gnome-2.26.0 )
	samba? ( || ( >=net-fs/samba-3.4.6[smbclient]
			<=net-fs/samba-3.3 ) )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.19
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1 )"


pkg_setup() {
	if use cdda && ! use hal && ! use udev; then
		ewarn "You have \"+cdda\", but you have \"-hal\" and \"-udev\""
		ewarn "cdda support will NOT be built unless you enable EITHER hal OR udev"
	fi

	G2CONF="${G2CONF}
		--enable-udev
		--disable-bash-completion
		--with-dbus-service-dir=/usr/share/dbus-1/services
		--disable-schemas-compile
		$(use_enable archive)
		$(use_enable avahi)
		$(use_enable bluetooth obexftp)
		$(use_enable cdda)
		$(use_enable fuse)
		$(use_enable gdu)
		$(use_enable gphoto2)
		$(use_enable iphone afc)
		$(use_enable udev gudev)
		$(use_enable hal)
		$(use_enable http)
		$(use_enable gnome-keyring keyring)
		$(use_enable samba)"
}

src_prepare() {
	gnome2_src_prepare

	# Conditional patching purely to avoid eautoreconf
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
