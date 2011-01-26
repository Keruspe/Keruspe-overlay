# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
GCONF_DEBUG="yes"
inherit gnome2 multilib pam virtualx

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc pam test"

RDEPEND=">=dev-libs/glib-2.25:2
	>=x11-libs/gtk+-2.91.1
	gnome-base/gconf
	>=sys-apps/dbus-1.0
	>=dev-libs/libgcrypt-1.2.2
	>=dev-libs/libtasn1-1
	sys-libs/libcap

	pam? ( virtual/pam )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.9 )"
PDEPEND="gnome-base/libgnome-keyring"

DOCS="AUTHORS ChangeLog NEWS README"

RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable test tests)
		$(use_enable pam)
		$(use_with pam pam-dir $(getpam_mod_dir))
		--with-root-certs=/etc/ssl/certs/
		--enable-acl-prompts
		--enable-ssh-agent
		--enable-gpg-agent
		--with-gtk=3.0"
}

src_prepare() {
	gnome2_src_prepare

	sed 's:CFLAGS="$CFLAGS -Werror:CFLAGS="$CFLAGS:' \
		-i configure.in configure || die "sed failed"

	sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' \
		-i configure.in configure || die "sed 2 failed"
}

src_install() {
	gnome2_src_install
	if use pam; then
		find "${ED}"/$(get_libdir)/security -name "*.la" -delete \
			|| die "la file removal failed"
	fi
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "emake check failed!"
}
