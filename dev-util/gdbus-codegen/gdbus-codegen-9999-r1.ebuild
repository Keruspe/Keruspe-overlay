# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GNOME_ORG_MODULE="glib"
PYTHON_DEPEND="2:2.5"
PYTHON_USE_WITH="xml"

inherit gnome2-live multilib python

DESCRIPTION="GDBus code and documentation generator"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}"
PDEPEND="~dev-libs/glib-9999"

S="${WORKDIR}/glib-${PV}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	G2CONF="$(use_enable doc man)"
}

src_compile() {
	cd "${S}/gio/gdbus-2.0/codegen"
	emake
	python_convert_shebangs 2 "gdbus-codegen"
	if use doc; then
		cd "${S}/gio"
		emake gio-public-headers.txt
		cd "${S}/docs/reference/gio/"
		emake gdbus-codegen.1
	fi
}

src_install() {
	cd "${S}/gio/gdbus-2.0/codegen"
	emake DESTDIR=${D} install
	if use doc; then
		doman "${WORKDIR}/glib-${PV}/docs/reference/gio/gdbus-codegen.1" ||
		die "doman failed"
	fi
}

src_test() {
	elog "Skipping tests. To test ${PN}, emerge dev-libs/glib"
	elog "with FEATURES=test"
}

pkg_postinst() {
	python_need_rebuild
	python_mod_optimize /usr/$(get_libdir)/gdbus-2.0/codegen
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/gdbus-2.0/codegen
}
