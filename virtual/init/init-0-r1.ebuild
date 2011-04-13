# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/init/init-0.ebuild,v 1.13 2010/01/11 11:02:32 ulm Exp $

DESCRIPTION="Virtual for various init implementations"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="kernel_linux? ( || ( sys-apps/systemd >=sys-apps/sysvinit-2.86-r6 sys-process/runit ) )
	kernel_FreeBSD? ( sys-freebsd/freebsd-sbin )"
DEPEND=""
