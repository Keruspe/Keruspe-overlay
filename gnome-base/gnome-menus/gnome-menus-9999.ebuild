# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $ 

EAPI="3"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

PYTHON_DEPEND="python? 2:2.4"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit eutils gnome2-live python

DESCRIPTION="The GNOME menu system, implementing the F.D.O cross-desktop spec"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS=""

IUSE="debug +introspection python"

RDEPEND=">=dev-libs/glib-2.18
	python? ( dev-python/pygtk )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40"

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	# Do NOT compile with --disable-debug/--enable-debug=no
	# It disables api usage checks
	if ! use debug ; then
		G2CONF="${G2CONF} --enable-debug=minimum"
	fi

	G2CONF="${G2CONF}
		--disable-static
		$(use_enable python)
		$(use_enable introspection)"
}

src_prepare() {
	gnome2_src_prepare

	# Don't show KDE standalone settings desktop files in GNOME others menu
	epatch "${FILESDIR}/${PN}-3.0.0-ignore_kde_standalone.patch"

	# disable pyc compiling
	mv py-compile py-compile-disabled
	ln -s $(type -P true) py-compile

	python_copy_sources
}

src_configure() {
	python_execute_function -s gnome2_src_configure
}

src_compile() {
	python_execute_function -s gnome2_src_compile
}

src_test() {
	python_execute_function -s -d
}

src_install() {
	python_execute_function -s gnome2_src_install
	python_clean_installation_image

	# Prefix menu, bug #256614
	mv "${ED}"/etc/xdg/menus/applications.menu \
		"${ED}"/etc/xdg/menus/gnome-applications.menu || die "menu move failed"

	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/10-xdg-menu-gnome" || die "doexe failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use python; then
		python_mod_optimize GMenuSimpleEditor
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm
	if use python; then
		python_mod_cleanup GMenuSimpleEditor
	fi
}
