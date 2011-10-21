# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2:2.5"

inherit python git-2 autotools

DESCRIPTION="A Jabber/XMPP connection manager, this handles single and multi user chats and voice calls."
HOMEPAGE="http://telepathy.freedesktop.org"
SRC_URI=""
EGIT_HAS_SUBMODULES="yes"
EGIT_REPO_URI="git://anongit.freedesktop.org/telepathy/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug test"

RDEPEND=">=dev-libs/glib-2.24:2
	>=sys-apps/dbus-1.1.0
	>=dev-libs/dbus-glib-0.82
	>=net-libs/telepathy-glib-0.16
	>=net-libs/libnice-0.0.11
	>=net-libs/gnutls-2.10.2

	dev-db/sqlite:3
	dev-libs/libxml2

	|| ( net-libs/libsoup:2.4[ssl]
		 >=net-libs/libsoup-2.33.1 )

	!<net-im/telepathy-mission-control-5.5.0"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-libs/libxslt
	test? ( >=dev-python/twisted-0.8.2
		>=dev-python/twisted-words-0.8.2
		>=dev-python/dbus-python-0.83 )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs -r 2 .
	pushd lib/ext/wocky >/dev/null
	gtkdocize --copy
	eautoreconf
	popd >/dev/null
	pushd lib/ext/telepathy-yell >/dev/null
	eautoreconf
	popd >/dev/null
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable debug handle-leak-debug)
}

src_test() {
	# Twisted tests fail, upstream bug #30565
	emake -C tests check-TESTS || die "tests failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS NEWS ChangeLog README || die "dodoc failed"
	find "${D}" -name '*.la' -exec rm -f {} +
}
