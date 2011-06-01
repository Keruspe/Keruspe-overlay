# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit base autotools


EAPI=4

DESCRIPTION="Library to use rabbitmq"
HOMEPAGE="http://hg.rabbitmq.com/rabbitmq-c"
SRC_URI="http://hg.rabbitmq.com/rabbitmq-codegen/archive/740afa9df161.tar.bz2
http://hg.rabbitmq.com/rabbitmq-c/archive/2c0ea67d4e40.tar.bz2"
RESTRICT="nomirror"

LICENSE="GPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

DEPEND="dev-python/simplejson"
RDEPEND=""

S="${WORKDIR}/rabbitmq-c-2c0ea67d4e40"
src_unpack() {
	unpack $A
	cd ${WORKDIR}
	ln -s rabbitmq-codegen-740afa9df161 rabbitmq-codegen
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_prepare() {
	eautoreconf
}

src_install() {
	base_src_install
	find $ED -name '*.la' -exec rm -f '{}' +
}
