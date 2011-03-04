# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"
inherit autotools gnome2 git python

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="http://live.gnome.org/Gjs"
EGIT_REPO_URI="git://git.gnome.org/gjs"
SRC_URI=""

LICENSE="MIT MPL-1.1 LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="coverage examples"

RDEPEND=">=dev-libs/glib-2.18:2
	>=dev-libs/gobject-introspection-0.10.1
	dev-libs/dbus-glib
	x11-libs/cairo
	|| ( >=net-libs/xulrunner-1.9.2:1.9
		 >=dev-lang/spidermonkey-1.9.2 )
	!<dev-lang/spidermonkey-1.9.2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	coverage? (
		sys-devel/gcc
		dev-util/lcov )"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	# AUTHORS, ChangeLog are empty
	DOCS="NEWS README"
	G2CONF="${G2CONF}
		$(use_enable coverage)"

	# If spidermonkey & xulrunner are installed configure prefers spidermonkey.
	# This will break gnome-shell if the user removes spidermonkey.
	# Mozilla wants to move to a split spidermonkey, so this problem should
	# solve itself in the future. For now, we add an ewarn.
	if has_version dev-lang/spidermonkey && has_version net-libs/xulrunner; then
		ewarn "You have both spidermonkey and xulrunner installed,"
		ewarn "hence gnome-shell will be linked with spidermonkey."
		ewarn "If you remove spidermonkey, you will need to recompile"
		ewarn "gnome-shell so that it links with xulrunner."
	fi

	gnome2_src_prepare
	python_convert_shebangs 2 "${S}"/scripts/make-tests
	eautoreconf
}

src_install() {
	gnome2_src_install -j1

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins ${S}/examples/* || die "doins examples failed!"
	fi

	find "${ED}" -name "*.la" -delete || die "la files removal failed"
}
