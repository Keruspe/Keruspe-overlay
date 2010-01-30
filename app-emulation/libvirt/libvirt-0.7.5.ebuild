# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

BACKPORTS=

EAPI="2"

inherit eutils python

DESCRIPTION="C toolkit to manipulate virtual machines"
HOMEPAGE="http://www.libvirt.org/"
SRC_URI="http://libvirt.org/sources/${P}.tar.gz
	${BACKPORTS:+mirror://gentoo/${P}-backports-${BACKPORTS}.tar.bz2}"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="avahi caps iscsi +libvirtd lvm +lxc +network nfs one nls numa openvz \
	parted phyp policykit python qemu sasl selinux uml virtualbox xen udev"

RESTRICT=test

RDEPEND="sys-libs/readline
	sys-libs/ncurses
	>=net-misc/curl-7.18.0
	>=dev-libs/libxml2-2.7.6
	>=net-libs/gnutls-1.0.25
	dev-lang/python
	sys-fs/sysfsutils
	sys-apps/util-linux
	>=net-analyzer/netcat6-1.0-r2
	avahi? ( >=net-dns/avahi-0.6[dbus] )
	caps? ( sys-libs/libcap-ng )
	iscsi? ( sys-block/open-iscsi )
	libvirtd? ( net-misc/bridge-utils )
	lvm? ( >=sys-fs/lvm2-2.02.48-r2 )
	nfs? ( net-fs/nfs-utils )
	numa? ( sys-process/numactl )
	one? ( dev-libs/xmlrpc-c )
	openvz? ( sys-kernel/openvz-sources )
	parted? ( >=sys-apps/parted-1.8 )
	phyp? ( net-libs/libssh2 )
	policykit? ( >=sys-auth/polkit-0.95 )
	qemu? ( || ( app-emulation/qemu-kvm >=app-emulation/qemu-0.10.0 ) )
	sasl? ( dev-libs/cyrus-sasl )
	selinux? ( sys-libs/libselinux )
	virtualbox? ( || ( >=app-emulation/virtualbox-ose-2.2.0 >=app-emulation/virtualbox-bin-2.2.0 ) )
	xen? ( app-emulation/xen-tools app-emulation/xen )
	udev? ( >=sys-fs/udev-145 >=x11-libs/libpciaccess-0.10.9 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	[[ -n ${BACKPORTS} ]] && \
		EPATCH_SUFFIX="patch" EPATCH_SOURCE="${S}/patches" epatch
}

src_configure() {
	local myconf=""
	myconf="${myconf} $(use_with libvirtd)"
	myconf="${myconf} $(use_with avahi)"
	myconf="${myconf} $(use_with xen) $(use_with xen xen-inotify)"
	if ! use policykit && use xen; then
		myconf="${myconf} --with-xen-proxy"
	fi
	myconf="${myconf} $(use_with openvz)"
	myconf="${myconf} $(use_with lxc)"
	myconf="${myconf} $(use_with virtualbox vbox)"
	myconf="${myconf} $(use_with uml)"
	myconf="${myconf} $(use_with qemu)"
	myconf="${myconf} $(use_with one)"
	myconf="${myconf} $(use_with phyp)"
	myconf="${myconf} --with-esx"
	myconf="${myconf} $(use_with network)"
	myconf="${myconf} --with-storage-fs"
	myconf="${myconf} $(use_with lvm storage-lvm)"
	myconf="${myconf} $(use_with iscsi storage-iscsi)"
	myconf="${myconf} $(use_with parted storage-disk)"
	myconf="${myconf} $(use_with lvm storage-mpath)"
	myconf="${myconf} $(use_with numa numactl)"
	myconf="${myconf} $(use_with selinux)"
	myconf="${myconf} $(use_with udev)"
	myconf="${myconf} $(use_with caps capng)"
	myconf="${myconf} $(use_with policykit polkit)"
	myconf="${myconf} $(use_with sasl)"
	myconf="${myconf} $(use_enable nls)"
	myconf="${myconf} $(use_with python)"
	myconf="${myconf} --without-netcf"
	myconf="${myconf} --without-hal"

	econf \
		${myconf} \
		--disable-static \
		--docdir=/usr/share/doc/${PF} \
		--with-remote \
		--localstatedir=/var \
		--with-remote-pid-file=/var/run/libvirtd.pid
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		HTML_DIR=/usr/share/doc/${PF}/html \
		DOCS_DIR=/usr/share/doc/${PF}/python \
		EXAMPLE_DIR=/usr/share/doc/${PF}/python/examples \
		|| die "emake install failed"

	newinitd "${FILESDIR}/libvirtd.init" libvirtd || die
	newconfd "${FILESDIR}/libvirtd.confd" libvirtd || die

	keepdir /var/lib/libvirt/images

	find "${D}" -name '*.la' -delete || die
}

pkg_preinst() {
	if [[ -e "${ROOT}"/etc/libvirt/qemu/networks/default.xml ]]; then
		rm -rf "${D}"/etc/libvirt/qemu/networks/default.xml
	fi
}

pkg_postinst() {
	use python && python_mod_optimize $(python_get_sitedir)/libvirt.py

	elog "To allow normal users to connect to libvirtd you must change the"
	elog " unix sock group and/or perms in /etc/libvirt/libvirtd.conf"
	elog
	elog "For the basic networking support (bridged and routed networks)"
	elog "you don't need any extra software. For more complex network modes"
	elog "including but not limited to NATed network, you'll need the"
	elog "following packages":
	elog
	elog "	net-dns/dnsmasq"
	elog "	net-firewall/iptables"
	elog "	net-firewall/ebtables"
	elog
	ewarn "If you have a DNS server setup on your machine, you will have"
	ewarn "to configure /etc/dnsmasq.conf to enable the following settings: "
	ewarn " bind-interfaces"
	ewarn " interface or except-interface"
	elog
	ewarn "Otherwise you might have issues with your existing DNS server."
}

pkg_postrm() {
	use python && python_mod_cleanup
}
