# Copyright 1999-2008 Gentoo Foundation
# Copyright 2009 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Leave it - it's locked, come back - it's back too..."
HOMEPAGE="http://blueproximity.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-python/pybluez
	dev-python/configobj
	dev-python/pygtk
	|| ( net-wireless/bluez net-wireless/bluez-utils )
	"

src_install() {
	insinto /opt/${PN}
	sed "s:^cd.*:cd /opt/${PN}:" -i ${P}.orig/start_proximity.sh
	doins ${P}.orig/*
	newbin ${P}.orig/start_proximity.sh blueproximity
}

