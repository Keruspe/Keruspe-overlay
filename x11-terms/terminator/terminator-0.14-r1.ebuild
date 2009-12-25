# Copyright 1999-2009 Gentoo Foundation
# Copyright 2009 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils

DESCRIPTION="Multiple GNOME terminals in one window"
HOMEPAGE="http://www.tenshu.net/terminator/"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${PN}_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/notify-python
	>=x11-libs/vte-0.16[python]"

src_prepare() {
	distutils_src_prepare
}
