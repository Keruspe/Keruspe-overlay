# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2

DESCRIPTION="Vala - Compiler for the GObject type system"
HOMEPAGE="http://live.gnome.org/Vala"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test +vapigen coverage"

RDEPEND=">=dev-libs/glib-2.14"
DEPEND="${RDEPEND}
	sys-devel/flex
	|| ( sys-devel/bison dev-util/byacc dev-util/yacc )
	dev-util/pkgconfig
	dev-libs/libxslt
	test? ( dev-libs/dbus-glib )"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable vapigen)
		$(use_enable coverage)"
	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

	if use coverage && has ccache ${FEATURES}; then
		ewarn "USE=coverage does not work well with ccache; valac and libvala"
		ewarn "built with ccache and USE=coverage create temporary files inside"
		ewarn "CCACHE_DIR and mess with ccache's working, as well as causing"
		ewarn "sandbox violations when used to compile other packages."
		ewarn "It is STRONGLY recommended that you disable one of them."
	fi
}
