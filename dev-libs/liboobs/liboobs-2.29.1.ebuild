# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="Liboobs is a wrapping library to the System Tools Backends."
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc hal"

RDEPEND=">=dev-libs/glib-2.14
	>=dev-libs/dbus-glib-0.70
	>=app-admin/system-tools-backends-2.5.4
	hal? ( >=sys-apps/hal-0.5.9 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.9 )"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare(){
	cd $S
	use hal || (epatch ${FILESDIR}/${P}-nohal.patch || die epatch failed)
}

pkg_setup() {
	G2CONF="${G2CONF} --disable-static"
}
