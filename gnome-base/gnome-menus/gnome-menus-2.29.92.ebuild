# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils gnome2

DESCRIPTION="The GNOME menu system, implementing the F.D.O cross-desktop spec"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug introspection python"

RDEPEND=">=dev-libs/glib-2.18.0
	python? (
		>=dev-lang/python-2.4.4-r5
		dev-python/pygtk )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	introspection? ( dev-libs/gobject-introspection )
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.40"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	if ! use debug ; then
		G2CONF="${G2CONF} --enable-debug=minimum"
	fi

	G2CONF="${G2CONF} $(use_enable python) $(use_enable introspection) --disable-static"
}

src_unpack() {
	gnome2_src_unpack
	epatch "${FILESDIR}/${PN}-2.18.3-ignore_kde_standalone.patch"
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"

	mv "${D}"/etc/xdg/menus/applications.menu \
		"${D}"/etc/xdg/menus/gnome-applications.menu || die "menu move failed"

	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/10-xdg-menu-gnome" || die "doexe failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	ewarn "Due to bug #256614, you might lose icons in applications menus."
	ewarn "If you use a login manager, please re-select your session."
	ewarn "If you use startx and have no .xinitrc, just export XSESSION=Gnome."
	ewarn "If you use startx and have .xinitrc, export XDG_MENU_PREFIX=gnome-."
}
