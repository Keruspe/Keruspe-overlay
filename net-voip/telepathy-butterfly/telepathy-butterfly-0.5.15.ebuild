# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.5"
inherit python multilib eutils

DESCRIPTION="An MSN connection manager for Telepathy"
HOMEPAGE="http://telepathy.freedesktop.org/releases/telepathy-butterfly/"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/telepathy-python-0.15.17
	>=dev-python/papyon-0.5.1
	>=net-libs/libproxy-0.3.1[python]"

DOCS="AUTHORS NEWS"

src_prepare() {
	epatch ${FILESDIR}/fail.patch
	mv py-compile py-compile-disabled
	ln -s $(type -P true) py-compile
}

src_install() {
	emake install DESTDIR="${ED}"
	python_convert_shebangs 2 "${ED}"usr/libexec/telepathy-butterfly
}
