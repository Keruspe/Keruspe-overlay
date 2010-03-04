# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit distutils

MY_P=${PN}_${PV/_pre/~svn}

DESCRIPTION="Oauth module for Python"
HOMEPAGE="http://code.google.com/p/oauth/"
SRC_URI="mirror://ubuntu/pool/main/p/${PN}/${MY_P}.orig.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.5"
