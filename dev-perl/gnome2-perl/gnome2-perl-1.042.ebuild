# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MODULE_AUTHOR=TSCH
EAPI=3
inherit perl-module

DESCRIPTION="Perl interface to the 2.x series of the Gnome libraries"
HOMEPAGE="http://gtk2-perl.sourceforge.net/"
SRC_URI="mirror://sourceforge/gtk2-perl/Gnome2-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/Gnome2-${PV}

RDEPEND=">=x11-libs/gtk+-2
	>=dev-perl/gtk2-perl-1.0
	gnome-base/libgnomeui
	gnome-base/libbonoboui
	>=dev-perl/gnome2-canvas-1.0
	>=dev-perl/glib-perl-1.04
	>=dev-perl/gnome2-vfs-perl-1.0
	dev-lang/perl"
DEPEND="${RDEPEND}
	>=dev-perl/extutils-depends-0.2
	>=dev-perl/extutils-pkgconfig-1.03"
SRC_TEST=do
