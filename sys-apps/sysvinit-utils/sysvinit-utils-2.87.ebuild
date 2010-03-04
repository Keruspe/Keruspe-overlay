# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs flag-o-matic

PATCH_VER="2"
MY_PN="sysvinit"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Sysvinit without /sbin/init (usefull with runit)"
HOMEPAGE="http://freshmeat.net/projects/sysvinit/"
SRC_URI="mirror://debian/pool/main/s/sysvinit/${MY_PN}_${PV}dsf.orig.tar.gz
	mirror://gentoo/${MY_P}-patches-${PATCH_VER}.tar.bz2"
F="ftp://ftp.cistron.nl/pub/people/miquels/software/${MY_P}.tar.gz
	ftp://sunsite.unc.edu/pub/Linux/system/daemons/init/${MY_P}.tar.gz
	http://www.gc-linux.org/down/isobel/kexec/sysvinit/sysvinit-2.86-kexec.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="selinux static"

RDEPEND="selinux? ( >=sys-libs/libselinux-1.28 )"
DEPEND="${RDEPEND}
	!sys-apps/sysvinit
	virtual/os-headers"

S=${WORKDIR}/${MY_P}dsf

src_unpack() {
	unpack ${A}
	cd "${S}"
	EPATCH_FORCE="yes" EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patches
	sed -i '/^STRIP/s|=.*|=:|' src/Makefile
}

src_compile() {
	local myconf

	tc-export CC
	use static && append-ldflags -static
	use selinux && myconf=WITH_SELINUX=yes
	emake -C src ${myconf} || die
}

src_install() {
	emake -C src \
		install \
		ROOT="${D}" \
		|| die "make install"
	dodoc README doc/*
	doinitd "${FILESDIR}"/{reboot,shutdown}.sh || die
	rm ${D}/sbin/{,tel}init ${D}/usr/share/man/man8/{,tel}init.8
}
