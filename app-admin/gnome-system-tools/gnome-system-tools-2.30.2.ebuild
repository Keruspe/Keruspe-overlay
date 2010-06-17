# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools gnome2

DESCRIPTION="Tools aimed to make easy the administration of UNIX systems"
HOMEPAGE="http://www.gnome.org/projects/gst/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nautilus nfs ntp policykit samba"

RDEPEND="
	>=dev-libs/liboobs-${PV}
	>=x11-libs/gtk+-2.11.3
	>=dev-libs/glib-2.15.2
	>=gnome-base/gconf-2.2
	dev-libs/dbus-glib
	sys-libs/cracklib
	nautilus? ( >=gnome-base/nautilus-2.9.90 )
	nfs? ( net-fs/nfs-utils )
	ntp? ( net-misc/ntp )
	samba? ( >=net-fs/samba-3 )
	policykit? ( >=gnome-extra/polkit-gnome-0.95 )"

DEPEND="${RDEPEND}
	>=app-admin/system-tools-backends-2.8.2
	>=app-text/gnome-doc-utils-0.3.2
	dev-util/pkgconfig
	>=dev-util/intltool-0.35.0"

DOCS="AUTHORS BUGS ChangeLog HACKING NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable policykit polkit-gtk)
		$(use_enable nautilus)
		--disable-static"

	if ! use nfs && ! use samba; then
		G2CONF="${G2CONF} --disable-shares"
	fi
}

src_unpack() {
	gnome2_src_unpack
	eautoreconf
}
