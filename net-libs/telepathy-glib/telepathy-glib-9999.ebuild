# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
PYTHON_DEPEND="2:2.5"

inherit git-2 autotools python virtualx

DESCRIPTION="GLib bindings for the Telepathy D-Bus protocol."
HOMEPAGE="http://telepathy.freedesktop.org"
SRC_URI=""
EGIT_REPO_URI="git://anongit.freedesktop.org/telepathy/telepathy-glib"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug +introspection +vala"

RDEPEND=">=dev-libs/glib-2.28.0:2
	>=dev-libs/dbus-glib-0.82
	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )
	vala? (
		dev-lang/vala:0.14[vapigen]
		>=dev-libs/gobject-introspection-0.9.6 )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-libs/libxslt
	>=dev-util/pkgconfig-0.21"

src_prepare() {
	python_convert_shebangs -r 2 examples tests tools
	gtkdocize
	eautoreconf
	MAKEOPTS+=" -j1"
	default_src_prepare
}

src_configure() {
	local myconf

	if use vala; then
		myconf="--enable-introspection
			VALAC=$(type -p valac-0.14)
			VAPIGEN=$(type -p vapigen-0.14)"
	fi

	econf --disable-static \
		PYTHON=$(PYTHON -2 -a) \
		$(use_enable debug backtrace) \
		$(use_enable debug handle-leak-debug) \
		$(use_enable debug debug-cache) \
		$(use_enable introspection) \
		$(use_enable vala vala-bindings) \
		${myconf}
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	# Needs dbus for tests (auto-launched)
	Xemake -j1 check || die
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog NEWS README

	find "${D}" -name '*.la' -exec rm -f '{}' + || die
}
