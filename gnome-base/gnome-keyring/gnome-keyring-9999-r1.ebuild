# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2-live multilib pam virtualx

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE="+caps debug doc pam test"
KEYWORDS=""

RDEPEND=">=dev-libs/glib-2.25:2
	>=x11-libs/gtk+-2.90.0:3
	gnome-base/gconf:2
	>=sys-apps/dbus-1.0
	>=dev-libs/libgcrypt-1.2.2
	>=dev-libs/libtasn1-1
	dev-libs/p11-kit
	caps? ( sys-libs/libcap-ng )
	pam? ( virtual/pam )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.9 )"
PDEPEND="gnome-base/libgnome-keyring"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable test tests)
		$(use_with caps libcap-ng)
		$(use_enable pam)
		$(use_with pam pam-dir $(getpam_mod_dir))
		--with-root-certs=${EPREFIX}/etc/ssl/certs/
		--enable-ssh-agent
		--enable-gpg-agent
		--disable-update-mime"
	MAKEOPTS+=" -j1"
}

src_prepare() {
	sed -e 's/^\(SUBDIRS = \.\)\(.*\)/\1/' \
		-i gcr/Makefile.* || die "sed failed"

	gnome2_src_prepare
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "emake check failed!"
}
