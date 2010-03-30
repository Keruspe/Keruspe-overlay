# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2 eutils

DESCRIPTION="Collection of network tools"
HOMEPAGE="http://www.gnome.org/projects/gnome-network/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

COMMON_DEPEND=">=x11-libs/gtk+-2.12:2
	>=gnome-base/gconf-2
	gnome-base/libgtop:2"
RDEPEND="${COMMON_DEPEND}
	|| ( net-analyzer/traceroute sys-freebsd/freebsd-usbin )
	net-dns/bind-tools
	userland_GNU? ( net-misc/netkit-fingerd net-misc/whois )
	userland_BSD? ( net-misc/bsdwhois )"

DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	app-text/gnome-doc-utils"

DOCS="AUTHORS ChangeLog NEWS README TODO"

G2CONF="${G2CONF}
	$(use_enable debug)
	--disable-scrollkeeper"

src_prepare() {
	gnome2_src_prepare

	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in || die "sed failed"
}
