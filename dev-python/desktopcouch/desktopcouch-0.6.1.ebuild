# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit distutils

DESCRIPTION="A CouchDB on every desktop, and the code to help it happen."
HOMEPAGE="https://launchpad.net/desktopcouch"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.5"
RDEPEND="dev-db/couchdb
	dev-python/couchdb-python
	dev-python/twisted
	net-dns/avahi[python]"
