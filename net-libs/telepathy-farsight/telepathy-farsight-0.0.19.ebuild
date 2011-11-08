# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
PYTHON_DEPEND="python? 2:2.6"

inherit python

DESCRIPTION="Farsight connection manager for the Telepathy framework"
HOMEPAGE="http://telepathy.freedesktop.org"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python"

RDEPEND=">=dev-libs/glib-2.16:2
	>=sys-apps/dbus-0.60
	>=dev-libs/dbus-glib-0.60
	>=net-libs/telepathy-glib-0.13.4
	>=net-libs/farsight2-0.0.17
	python? (
		>=dev-python/pygobject-2.12.0:2
		>=dev-python/gst-python-0.10.10 )"

DEPEND="${RDEPEND}"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	if use python; then
		python_convert_shebangs -r 2 .
	fi
}

src_configure() {
	econf $(use_enable python) --disable-static
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	if use python; then
		python_clean_installation_image
	fi
	dodoc NEWS ChangeLog || die
}
