# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2:2.5"

inherit python

DESCRIPTION="An account manager and channel dispatcher for the Telepathy framework."
HOMEPAGE="http://telepathy.freedesktop.org/wiki/Mission%20Control"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome-keyring networkmanager test upower"

RDEPEND=">=net-libs/telepathy-glib-0.13.14
	>=dev-libs/dbus-glib-0.82
	gnome-keyring? ( || ( gnome-base/libgnome-keyring <gnome-base/gnome-keyring-2.29.4 ) )
	networkmanager? ( >=net-misc/networkmanager-0.7.0 )
	upower? ( sys-power/upower )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-libs/libxslt
	test? ( dev-python/twisted-words )"

# Tests are broken, see upstream bug #29334
# upstream doesn't want it enabled everywhere
RESTRICT="test"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	python_convert_shebangs -r 2 .
}

src_configure() {
	# creds is not available and no support mcd-plugins for now
	econf --disable-static\
		--disable-mcd-plugins \
		$(use_enable gnome-keyring) \
		$(use_enable upower) \
		$(use_with networkmanager conectivity nm)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog || die

	find "${ED}" -name '*.la' -exec rm -f '{}' + || die
}
