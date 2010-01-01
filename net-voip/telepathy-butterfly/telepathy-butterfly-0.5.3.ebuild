# Copyright 1999-2010 Gentoo Foundation
# Copyright 2009-2010 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

NEED_PYTHON="2.6"

inherit python multilib

DESCRIPTION="An MSN connection manager for Telepathy"
HOMEPAGE="http://telepathy.freedesktop.org/releases/telepathy-butterfly/"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-python/telepathy-python-0.15.11
	>=dev-python/papyon-0.4.2"

DOCS="AUTHORS NEWS"

src_configure() {
	./waf --prefix=/usr \
		configure || die "./waf configure failed"
}

src_compile() {
	local myjobs=$(echo "$MAKEOPTS" | sed -n -e 's,.*\(-j[[:digit:]]\+\).*,\1,p')
	./waf ${myjobs} build || die "./waf build failed"
}

src_install() {
	./waf \
		--destdir="${D}" \
		install || die "./waf install failed"
	rm -f $(find "${D}" -name *.py[co])
	dodoc ${DOCS}
}

pkg_postinst() {
	python_version
	python_mod_optimize \
		/usr/$(get_libdir)/python${PYVER}/site-packages/butterfly
}

pkg_postrm() {
	python_mod_cleanup
}
