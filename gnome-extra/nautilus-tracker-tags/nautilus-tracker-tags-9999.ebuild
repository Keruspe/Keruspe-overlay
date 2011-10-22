# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GNOME_ORG_MODULE="tracker"

inherit gnome2-live toolchain-funcs

DESCRIPTION="Nautilus extension to tag files for Tracker"
HOMEPAGE="http://www.tracker-project.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND=">=app-misc/tracker-${PV}
	>=dev-libs/glib-2.28:2
	>=gnome-base/nautilus-2.90
	x11-libs/gtk+:3"
RDEPEND="${COMMON_DEPEND}
	!<app-misc/tracker-0.12.5-r1[nautilus]"
# Before tracker-0.12.5-r1, nautilus-tracker-tags was part of tracker
DEPEND="${COMMON_DEPEND}"

pkg_setup() {
	tc-export CC
	export TRACKER_API="0.14"
}

src_prepare() {
	cd src/plugins/nautilus
	cp "${FILESDIR}/0.12.5-Makefile" Makefile || die "cp failed"
	sed -e 's:#include "config.h"::' -i *.c *.h || die "sed failed"
}

src_configure() {
	:
}

src_compile() {
	cd src/plugins/nautilus
	emake
}

src_install() {
	cd src/plugins/nautilus
	emake DESTDIR="${D}" install
}
