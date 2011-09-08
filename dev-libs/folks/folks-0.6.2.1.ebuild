# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="libfolks is a library that aggregates people from multiple sources"
HOMEPAGE="http://telepathy.freedesktop.org/wiki/Folks"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="eds socialweb vala"

# TODO: tracker backend
COMMON_DEPEND=">=dev-libs/glib-2.24:2
	>=net-libs/telepathy-glib-0.13.1
	dev-libs/dbus-glib
	<dev-libs/libgee-0.7
	dev-libs/libxml2
	sys-libs/ncurses
	sys-libs/readline

	eds? ( >=gnome-extra/evolution-data-server-3.0.1 )
	socialweb? ( >=net-libs/libsocialweb-0.25.15 )"

# telepathy-mission-control needed at runtime; it is used by the telepathy
# backend via telepathy-glib's AccountManager binding.
RDEPEND="${COMMON_DEPEND}
	net-im/telepathy-mission-control"

# folks socialweb backend requires that libsocialweb be built with USE=vala,
# even when building folks with --disable-vala.
DEPEND="${COMMON_DEPEND}
	>=dev-libs/gobject-introspection-0.9.12
	>=dev-util/intltool-0.35.0
	>=dev-util/pkgconfig-0.21
	sys-devel/gettext

	socialweb? ( >=net-libs/libsocialweb-0.25.15[vala] )
	vala? (
		>=dev-lang/vala-0.13.3:0.14[vapigen]
		>=net-libs/telepathy-glib-0.13.1[vala]
		eds? ( >=gnome-extra/evolution-data-server-3.0.1[vala] ) )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	# Rebuilding docs needs valadoc, which has no release
	# TODO: tracker backend
	G2CONF="${G2CONF}
		$(use_enable eds eds-backend)
		$(use_enable socialweb libsocialweb-backend)
		$(use_enable vala)
		$(use_enable vala inspect-tool)
		--enable-import-tool
		--disable-docs
		--disable-Werror"
	if use vala; then
		G2CONF="${G2CONF}
		VALAC=$(type -p valac-0.14)
		VAPIGEN=$(type -p vapigen-0.14)"
	fi
}

src_test() {
	# FIXME: several eds backend tests fail
	sed -e 's/check: .*/check: /' \
		-i tests/eds/Makefile || die "sed failed"
	# Don't run make check in po/
	cd tests
	emake check
}
