# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit alternatives gnome2-live

DESCRIPTION="Vala - Compiler for the GObject type system"
HOMEPAGE="http://live.gnome.org/Vala"

LICENSE="LGPL-2.1"
SLOT="0.16"
KEYWORDS=""
IUSE="bootstrap test +vapigen"

RDEPEND=">=dev-libs/glib-2.16:2"
DEPEND="${RDEPEND}
	bootstrap? ( dev-lang/vala:0.14 )
	!bootstrap? ( dev-lang/vala:0.16 )
	sys-devel/flex
	|| ( sys-devel/bison dev-util/byacc dev-util/yacc )
	dev-util/pkgconfig
	dev-libs/libxslt
	test? (
		dev-libs/dbus-glib
		>=dev-libs/glib-2.26:2 )"

pkg_setup() {
	local VER
	if use bootstrap; then
		VER=0.14
	else
		VER=0.16
	fi
	G2CONF="${G2CONF}
		VALAC=$(type -P valac-${VER})
		--disable-unversioned
		--disable-maintainer-mode
		$(use_enable vapigen)"
	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
}

src_install() {
	gnome2_src_install
	mv "${ED}"/usr/share/aclocal/vala.m4 \
		"${ED}"/usr/share/aclocal/vala-${SLOT/./-}.m4 || die "failed to move vala m4 macro"
}

pkg_postinst() {
	gnome2_pkg_postinst
	alternatives_auto_makesym /usr/share/aclocal/vala.m4 "vala-0-[0-9][0-9].m4"
}

pkg_postrm() {
	gnome2_pkg_postrm
	alternatives_auto_makesym /usr/share/aclocal/vala.m4 "vala-0-[0-9][0-9].m4"
}
