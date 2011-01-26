# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit distutils eutils

DESCRIPTION="Python MSN IM protocol implementation forked from pymsn"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/papyon"
SRC_URI="http://www.freedesktop.org/software/${PN}/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.5
	>=dev-python/pygobject-2.10
	>=dev-python/pyopenssl-0.6
	dev-python/gst-python
	dev-python/pycrypto
	net-libs/farsight2[python]"
DEPEND="${RDEPEND}"
