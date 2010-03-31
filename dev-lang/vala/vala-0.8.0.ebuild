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
IUSE="test +vapigen +coverage"

RDEPEND=">=dev-libs/glib-2.12"
DEPEND="${RDEPEND}
	sys-devel/flex
	|| ( sys-devel/bison dev-util/byacc dev-util/yacc )
	dev-util/pkgconfig
	dev-libs/libxslt
	test? ( dev-libs/dbus-glib )"

G2CONF="${G2CONF}
	$(use_enable vapigen)
	$(use_enable coverage)"
DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
