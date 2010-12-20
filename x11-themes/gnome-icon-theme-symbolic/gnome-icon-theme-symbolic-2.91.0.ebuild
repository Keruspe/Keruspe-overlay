# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="GNOME 2 symbolic icon themes"
HOMEPAGE="http://www.gnome.org/"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-themes/hicolor-icon-theme-0.10"
DEPEND="${RDEPEND}
	>=x11-misc/icon-naming-utils-0.8.7
	>=dev-util/pkgconfig-0.19"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

# FIXME: double check potential LINGUAS problem
pkg_setup() {
	DOCS="AUTHORS NEWS"
	G2CONF="${G2CONF} --enable-icon-mapping"
}
