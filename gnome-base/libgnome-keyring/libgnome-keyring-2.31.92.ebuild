# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnome-keyring/libgnome-keyring-2.30.1.ebuild,v 1.6 2010/08/11 16:26:23 josejx Exp $

EAPI=2

inherit eutils gnome2

DESCRIPTION="Compatibility library for accessing secrets"
HOMEPAGE="http://live.gnome.org/GnomeKeyring"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc x86"
IUSE="debug doc test"

RDEPEND=">=sys-apps/dbus-1.0
	>=dev-libs/eggdbus-0.4
	gnome-base/gconf
	>=gnome-base/gnome-keyring-2.29
	!<gnome-base/gnome-keyring-2.29"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.9 )"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable test tests)"
}
