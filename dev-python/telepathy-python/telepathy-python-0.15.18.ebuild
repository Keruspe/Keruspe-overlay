# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit base

DESCRIPTION="Telepathy Python base classes for use in connection managers, and proxy classes for use in clients."
HOMEPAGE="http://telepathy.freedesktop.org/"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libxslt"
RDEPEND=">=dev-python/dbus-python-0.80"

MAKEOPTS="-j1"

DOCS="AUTHORS NEWS"
