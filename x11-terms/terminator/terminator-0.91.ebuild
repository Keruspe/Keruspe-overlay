# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit distutils eutils

PYTHON_DEPEND="2"
PYTHON_MODNAME="terminatorlib"

DESCRIPTION="Multiple GNOME terminals in one window"
HOMEPAGE="http://www.tenshu.net/terminator/"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

RDEPEND="
	gnome? ( dev-python/gnome-python )
	>=x11-libs/vte-0.16[python]"
DEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${PV}-without-icon-cache.patch
	distutils_src_prepare
}
