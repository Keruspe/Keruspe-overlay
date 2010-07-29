# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome.org eutils autotools

MY_PN=${PN/networkmanager/NetworkManager}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Network configuration and management in an easy way. Desktop environment independent."
HOMEPAGE="http://www.gnome.org/projects/NetworkManager/"
SRC_URI="${SRC_URI//${PN}/${MY_PN}}
	http://dev.gentoo.org/~dagger/files/${PN}-ifnet.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="avahi bluetooth doc modem nss gnutls dhclient dhcpcd resolvconf connection-sharing"

RDEPEND=">=sys-apps/dbus-1.2
	>=dev-libs/dbus-glib-0.75
	>=net-wireless/wireless-tools-28_pre9
	>=sys-fs/udev-145[extras]
	>=dev-libs/glib-2.18
	>=sys-auth/polkit-0.92
	>=dev-libs/libnl-1.1
	modem? ( >=net-misc/modemmanager-0.2 )
	>=net-wireless/wpa_supplicant-0.5.10[dbus]
	bluetooth? ( net-wireless/bluez )
	|| ( sys-libs/e2fsprogs-libs <sys-fs/e2fsprogs-1.41.0 )
	avahi? ( net-dns/avahi[autoipd] )
	gnutls? (
		nss? ( >=dev-libs/nss-3.11 )
		!nss? ( dev-libs/libgcrypt
			net-libs/gnutls ) )
	!gnutls? ( >=dev-libs/nss-3.11 )
	dhclient? (
		dhcpcd? ( >=net-misc/dhcpcd-4.0.0_rc3 )
		!dhcpcd? ( >=net-misc/dhcp-3.0.0 ) )
	!dhclient? ( >=net-misc/dhcpcd-4.0.0_rc3 )
	resolvconf? ( net-dns/openresolv )
	connection-sharing? (
		net-dns/dnsmasq
		net-firewall/iptables )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	net-dialup/ppp
	doc? ( >=dev-util/gtk-doc-1.8 )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${P}-confchanges.patch"
	epatch "${DISTDIR}/${PN}-ifnet.patch"
	eautoreconf
}

src_configure() {
	ECONF="--disable-more-warnings
		--localstatedir=/var
		--with-distro=gentoo
		--with-dbus-sys-dir=/etc/dbus-1/system.d
		--with-udev-dir=/etc/udev
		--with-iptables=/sbin/iptables
		$(use_enable doc gtk-doc)
		$(use_with doc docs)
		$(use_with resolvconf)"

	if use dhclient ; then
		if use dhcpcd ; then
			ECONF="${ECONF} --with-dhcp-client=dhcpcd"
		else
			ECONF="${ECONF} --with-dhcp-client=dhclient"
		fi
	else
		ECONF="${ECONF} --with-dhcp-client=dhcpcd"
	fi

	if use gnutls ; then
		if use nss ; then
			ECONF="${ECONF} --with-crypto=nss"
		else
			ECONF="${ECONF} --with-crypto=gnutls"
		fi
	else
		ECONF="${ECONF} --with-crypto=nss"
	fi

	econf ${ECONF}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	keepdir /var/run/NetworkManager
	keepdir /etc/NetworkManager/dispatcher.d
	dodoc AUTHORS ChangeLog NEWS README TODO || die "dodoc failed"
	keepdir /etc/NetworkManager/system-connections
	insinto /etc/NetworkManager
	newins "${FILESDIR}/nm-system-settings.conf" nm-system-settings.conf \
		|| die "newins failed"
}

pkg_postinst() {
	elog "You will need to reload DBus if this is your first time installing"
	elog "NetworkManager, or if you're upgrading from 0.7 or older."
	elog ""
}
