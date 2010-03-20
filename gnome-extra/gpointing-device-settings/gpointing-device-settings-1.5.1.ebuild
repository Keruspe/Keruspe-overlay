# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils gnome2

DESCRIPTION="A GTK+ based configuration utility for the synaptics driver"
HOMEPAGE="http://gsynaptics.sourceforge.jp/"
SRC_URI="http://globalbase.dl.sourceforge.jp/gsynaptics/45812/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.10
	>=x11-libs/gtk+-2.14.0
	>=gnome-base/gconf-2.24
	>=x11-libs/libXi-1.2
	!<=x11-base/xorg-server-1.6.0
	!gnome-extra/gsynaptics"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19
	>=dev-util/intltool-0.35.5"

DOCS="MAINTAINERS NEWS TODO"
