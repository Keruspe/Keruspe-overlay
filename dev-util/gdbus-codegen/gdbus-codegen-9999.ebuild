# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GNOME_LIVE_MODULE="glib"
PYTHON_DEPEND="2:2.5"
PYTHON_USE_WITH="xml"

inherit gnome2-live multilib python

DESCRIPTION="GDBus code and documentation generator"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc" # use doc needs fixing

DEPEND=""
RDEPEND="${DEPEND}
	~dev-libs/glib-9999"

S="${WORKDIR}/glib-${PV}"

pkg_setup() {
	python_set_active_version 2
	G2CONF="$(use_enable doc man)"
}

src_compile() {
	cd "${S}/gio/gdbus-2.0/codegen"
	emake
	if use doc; then
		cd "${S}/docs/reference/gio/"
		emake
	fi
	python_convert_shebangs 2 "gdbus-codegen"
}

src_install() {
	cd "${S}/gio/gdbus-2.0/codegen"
	insinto "/usr/$(get_libdir)/gdbus-2.0/codegen"
	# keep in sync with Makefile.am
	doins __init__.py \
		codegen.py \
		codegen_main.py \
		codegen_docbook.py \
		config.py \
		dbustypes.py \
		parser.py \
		utils.py || die "doins failed"
	newbin gdbus-codegen.in gdbus-codegen || die "dobin failed"
	use doc && {
		doman "${WORKDIR}/glib-${PV}/docs/reference/gio/gdbus-codegen.1" ||
		die "doman failed"
	}
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
