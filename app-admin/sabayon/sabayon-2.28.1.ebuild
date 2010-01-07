# Copyright 1999-2010 Gentoo Foundation
# Copyright 2009-2010 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
GCONF_DEBUG="no"

inherit gnome2 eutils python multilib

DESCRIPTION="Tool to maintain user profiles in a GNOME desktop"
HOMEPAGE="http://www.gnome.org/projects/sabayon/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

COMMON_DEPEND=">=dev-lang/python-2.4
	>=x11-libs/gtk+-2.6.0
	>=dev-python/pygtk-2.5.3
	>=dev-python/pygobject-2.15
	x11-libs/pango
	dev-python/python-ldap
	x11-base/xorg-server[kdrive]"

RDEPEND="${COMMON_DEPEND}
	dev-python/pyxdg
	dev-libs/libxml2[python]
	>=gnome-base/gconf-2.8.1
	>=dev-python/libbonobo-python-2.6
	>=dev-python/gconf-python-2.6"

DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40"

DOCS="AUTHORS ChangeLog ISSUES NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--with-distro=gentoo
		--with-prototype-user=${PN}-admin
		--enable-console-helper=no"

	einfo "Adding user '${PN}-admin' as the prototype user"
	# I think /var/lib/sabayon is the correct directory to use here.
	enewgroup ${PN}-admin
	enewuser ${PN}-admin -1 -1 "/var/lib/sabayon" "${PN}-admin"
	# Should we delete the user/group on unmerge?
}

src_prepare() {
	gnome2_src_prepare

	# Switch gnomesu to gksu; bug #197865
	sed -i 's/Exec=/Exec=gksu /' admin-tool/sabayon.desktop || die "gksu sed failed"
	sed -i 's/Exec=/Exec=gksu /' admin-tool/sabayon.desktop.in || die "gksu sed failed"

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize $(python_get_sitedir)/sabayon

	# unfortunately /etc/gconf is CONFIG_PROTECT_MASK'd
	elog "To apply Sabayon defaults and mandatory settings to all users, put"
	elog '    include "$(HOME)/.gconf.path.mandatory"'
	elog "in /etc/gconf/2/local-mandatory.path and put"
	elog '    include "$(HOME)/.gconf.path.defaults"'
	elog "in /etc/gconf/2/local-defaults.path."
	elog "You can safely create these files if they do not already exist."
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/sabayon
}
