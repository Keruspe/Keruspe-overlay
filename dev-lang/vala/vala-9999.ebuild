# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit alternatives gnome2-live

DESCRIPTION="Vala - Compiler for the GObject type system"
HOMEPAGE="http://live.gnome.org/Vala"

LICENSE="LGPL-2.1"
SLOT="0.18"
OLD_SLOT="0.16"
KEYWORDS=""
IUSE="bootstrap test +vapigen"

RDEPEND=">=dev-libs/glib-2.16:2"
DEPEND="${RDEPEND}
	!bootstrap? ( dev-lang/vala:${SLOT} )
	bootstrap? ( dev-lang/vala:${OLD_SLOT} )
	sys-devel/flex
	|| ( sys-devel/bison dev-util/byacc dev-util/yacc )
	dev-util/pkgconfig
	dev-libs/libxslt
	test? (
		dev-libs/dbus-glib
		>=dev-libs/glib-2.26:2 )"

pkg_setup() {
	local WANTED_SLOT
	if use bootstrap; then
		WANTED_SLOT=${OLD_SLOT}
	else
		WANTED_SLOT=${SLOT}
	fi
	G2CONF="${G2CONF}
		VALAC=$(type -P valac-${WANTED_SLOT})
		--disable-unversioned
		$(use_enable vapigen)"
	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
}

src_install() {
	gnome2_src_install

	insinto /usr/share/aclocal
	newins vala.m4 vala-${SLOT/./-}.m4
}

pkg_postinst() {
	gnome2_pkg_postinst
	alternatives_auto_makesym /usr/share/aclocal/vala.m4 "vala-0-[0-9][0-9].m4"
}

pkg_postrm() {
	gnome2_pkg_postrm
	alternatives_auto_makesym /usr/share/aclocal/vala.m4 "vala-0-[0-9][0-9].m4"
}
