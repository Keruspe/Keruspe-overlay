# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

inherit eutils gnome2-live

DESCRIPTION="git repository viewer for GNOME"
HOMEPAGE="http://trac.novowork.com/gitg/"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS=""
IUSE="debug glade"

RDEPEND=">=dev-libs/glib-2.26:2
	>=x11-libs/gtk+-3.0.0:3
	>=x11-libs/gtksourceview-3.1.3:3.0
	>=gnome-base/gconf-2.10:2
	>=gnome-base/gsettings-desktop-schemas-0.1.1
	dev-vcs/git
	glade? ( >=dev-util/glade-3.2:3.10 )
"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.17
	>=dev-util/pkgconfig-0.15
	>=dev-util/intltool-0.40"

pkg_setup() {
	# Disable maintainer to get rid of -Werror  (bug #363009)
	G2CONF="${G2CONF}
		--disable-static
		--disable-deprecations
		--disable-dependency-tracking
		--disable-maintainer-mode
		$(use_enable debug)
		$(use_enable glade glade-catalog)"

	DOCS="AUTHORS ChangeLog NEWS README"
}

src_test() {
	emake check
}
