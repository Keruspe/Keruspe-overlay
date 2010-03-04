# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils multilib toolchain-funcs autotools

DESCRIPTION="User-land utilities for LVM2 (device-mapper) software."
HOMEPAGE="http://sources.redhat.com/lvm2/"
SRC_URI="ftp://sources.redhat.com/pub/lvm2/${PN/lvm/LVM}.${PV}.tgz
		 ftp://sources.redhat.com/pub/lvm2/old/${PN/lvm/LVM}.${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="readline +static clvm cman +lvm1 selinux"

DEPEND_COMMON="!!sys-fs/device-mapper
	clvm? ( =sys-cluster/dlm-2*
			cman? ( =sys-cluster/cman-2* ) )"

RDEPEND="${DEPEND_COMMON}
	!<sys-apps/openrc-0.4
	!!sys-fs/lvm-user
	!!sys-fs/clvm
	>=sys-apps/util-linux-2.16"

DEPEND="${DEPEND_COMMON}
		dev-util/pkgconfig"

S="${WORKDIR}/${PN/lvm/LVM}.${PV}"

pkg_setup() {
	if use static; then
		elog "Warning, we no longer overwrite /sbin/lvm and /sbin/dmsetup with"
		elog "their static versions. If you need the static binaries,"
		elog "you must append .static the filename!"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.02.56-dmeventd.patch
	epatch "${FILESDIR}"/lvm.conf-2.02.56.patch
	epatch "${FILESDIR}"/${PN}-2.02.56-device-mapper-export-format.patch
	epatch "${FILESDIR}"/${PN}-2.02.56-always-make-static-libdm.patch
	epatch "${FILESDIR}"/lvm2-2.02.56-lvm2create_initrd.patch

	eautoreconf
}

src_configure() {
	local myconf
	local buildmode

	myconf="${myconf} --enable-dmeventd"
	myconf="${myconf} --enable-cmdlib"
	myconf="${myconf} --enable-applib"
	myconf="${myconf} --enable-fsadm"

	if use static ; then
		einfo "Building static LVM, for usage inside genkernel"
		buildmode="internal"
		myconf="${myconf} --enable-static_link"
	else
		ewarn "Building shared LVM, it will not work inside genkernel!"
		buildmode="shared"
	fi

	myconf="${myconf} --with-mirrors=internal"
	myconf="${myconf} --with-snapshots=internal"

	if use lvm1 ; then
		myconf="${myconf} --with-lvm1=${buildmode}"
	else
		myconf="${myconf} --with-lvm1=none"
	fi

	use hppa && myconf="${myconf} --disable-o_direct"

	if use clvm; then
		myconf="${myconf} --with-cluster=${buildmode}"
		local clvmd=""
		use cman && clvmd="cman"
		[ -z "${clvmd}" ] && clvmd="none"
		myconf="${myconf} --with-clvmd=${clvmd}"
		myconf="${myconf} --with-pool=${buildmode}"
	else
		myconf="${myconf} --with-clvmd=none --with-cluster=none"
	fi

	myconf="${myconf} --sbindir=/sbin --with-staticdir=/sbin"
	econf $(use_enable readline) \
		$(use_enable selinux) \
		--enable-pkgconfig \
		--libdir=/usr/$(get_libdir) \
		${myconf} \
		CLDFLAGS="${LDFLAGS}" || die
}

src_compile() {
	einfo "Doing symlinks"
	pushd include
	emake || die "Failed to prepare symlinks"
	popd

	einfo "Starting main build"
	emake || die "compile fail"
}

src_install() {
	emake DESTDIR="${D}" install

	dodir /$(get_libdir)
	for i in \
		libdevmapper-event{,-lvm2{mirror,snapshot}} \
		libdevmapper \
		liblvm2{format1,snapshot,cmd} \
		; do
		b="${D}"/usr/$(get_libdir)/${i}
		if [ -f "${b}".so ]; then
			mv -f "${b}".so* "${D}"/$(get_libdir) || die
			gen_usr_ldscript ${i}.so || die
		fi
	done

	dodoc README VERSION WHATS_NEW doc/*.{conf,c,txt}
	insinto /$(get_libdir)/rcscripts/addons
	newins "${FILESDIR}"/lvm2-start.sh-2.02.49-r3 lvm-start.sh || die
	newins "${FILESDIR}"/lvm2-stop.sh-2.02.49-r3 lvm-stop.sh || die
	newinitd "${FILESDIR}"/lvm.rc-2.02.51-r2 lvm || die
	newconfd "${FILESDIR}"/lvm.confd-2.02.28-r2 lvm || die
	if use clvm; then
		newinitd "${FILESDIR}"/clvmd.rc-2.02.39 clvmd || die
		newconfd "${FILESDIR}"/clvmd.confd-2.02.39 clvmd || die
	fi

	dolib.a libdm/ioctl/libdevmapper.a || die "dolib.a libdevmapper.a"

	dosbin "${S}"/scripts/lvm2create_initrd/lvm2create_initrd
	doman  "${S}"/scripts/lvm2create_initrd/lvm2create_initrd.8
	newdoc "${S}"/scripts/lvm2create_initrd/README README.lvm2create_initrd

	insinto /etc
	doins "${FILESDIR}"/dmtab
	insinto /$(get_libdir)/rcscripts/addons
	doins "${FILESDIR}"/dm-start.sh

	newinitd "${FILESDIR}"/device-mapper.rc-1.02.51-r2 device-mapper || die
	newconfd "${FILESDIR}"/device-mapper.conf-1.02.22-r3 device-mapper || die

	newinitd "${FILESDIR}"/1.02.22-dmeventd.initd dmeventd || die
	dolib.a daemons/dmeventd/libdevmapper-event.a \
	|| die "dolib.a libdevmapper-event.a"

	insinto /etc/udev/rules.d/
	newins "${FILESDIR}"/64-device-mapper.rules-2.02.56-r3 64-device-mapper.rules || die

	sed -e "s-/lib/rcscripts/-/$(get_libdir)/rcscripts/-" -i "${D}"/etc/init.d/*

	elog "USE flag nocman is deprecated and replaced"
	elog "with the cman USE flag."
	elog ""
	elog "USE flags clvm and cman are masked"
	elog "by default and need to be unmasked to use them"
	elog ""
	elog "If you are using genkernel and root-on-LVM, rebuild the initramfs."
}

pkg_postinst() {
	elog "lvm volumes are no longer automatically created for"
	elog "baselayout-2 users. If you are using baselayout-2, be sure to"
	elog "run: # rc-update add lvm boot"
	elog "Do NOT add it if you are using baselayout-1 still."
}

src_test() {
	einfo "Testcases disabled because of device-node mucking"
	einfo "If you want them, compile the package and see ${S}/tests"
}
