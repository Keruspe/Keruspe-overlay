# Copyright 1999-2010 Gentoo Foundation
# Copyright 2009-2010 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils gnome2 flag-o-matic

DESCRIPTION="GNOME CUPS Printer Management Interface"
HOMEPAGE="http://www.gnome.org/"

SRC_URI="${SRC_URI}
	mirror://gentoo/${PN}-patches-${PVR}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.3.1
	>=dev-libs/glib-2.3.1
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2.2
	>=gnome-base/libglade-2
	>=gnome-base/libbonobo-2
	>=net-print/libgnomecups-0.2.3
	gnome-base/gnome-keyring"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.28"

DOCS="ChangeLog NEWS README"

src_unpack() {
	gnome2_src_unpack

	rm "${WORKDIR}"/patches/140_all_ui_tooltip.patch || \
		die "removing patch failed"

	export	EPATCH_SOURCE="${WORKDIR}/patches" \
		EPATCH_SUFFIX="patch" \
		EPATCH_MULTI_MSG="Applying Ubuntu patches (enhancements) ..."
	epatch
}

src_install() {
	gnome2_src_install
	#Debian-specific.
	rm "${D}"/usr/sbin/gnome-cups-switch
}
