# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
GCONF_DEBUG="yes"

inherit gnome2

DESCRIPTION="A GNOME application for managing encryption keys"
HOMEPAGE="http://www.gnome.org/projects/seahorse/index.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="avahi debug doc +introspection ldap libnotify test"

RDEPEND="
	>=gnome-base/gconf-2
	>=dev-libs/glib-2.10:2
	>=x11-libs/gtk+-2.90.7:3[introspection?]
	>=dev-libs/dbus-glib-0.72
	>=gnome-base/gnome-keyring-2.91.4
	net-libs/libsoup:2.4
	x11-misc/shared-mime-info

	net-misc/openssh
	>=app-crypt/gpgme-1
	|| (
		=app-crypt/gnupg-2.0*
		=app-crypt/gnupg-1.4* )

	avahi? ( >=net-dns/avahi-0.6 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.4 )
	ldap? ( net-nds/openldap )
	libnotify? ( >=x11-libs/libnotify-0.3.2 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=app-text/gnome-doc-utils-0.3.2
	>=app-text/scrollkeeper-0.3
	>=dev-util/pkgconfig-0.20
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-1.9 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-pgp
		--enable-ssh
		--enable-pkcs11
		--disable-static
		--disable-scrollkeeper
		--disable-update-mime-database
		--enable-hkp
		--with-gtk=3.0
		$(use_enable avahi sharing)
		$(use_enable debug)
		$(use_enable introspection)
		$(use_enable ldap)
		$(use_enable libnotify)
		$(use_enable test tests)"
	DOCS="AUTHORS ChangeLog NEWS README TODO THANKS"
}

src_prepare() {
	gnome2_src_prepare
	sed -i '/gdkconfig/d' libegg/eggsmclient-private.h
	sed -i -e 's:gcr-certificate.h:gcr.h:g' \
		-e 's:gcr-certificate-widget.h:gcr.h:g' \
		-e '/pkcs11g.h/g'
		pkcs11/seahorse-pkcs11-certificate.c \
		pkcs11/seahorse-pkcs11-certificate-props.h \
		pkcs11/seahorse-pkcs11-certificate-props.c \
		pkcs11/seahorse-pkcs11-helpers.c \
		pkcs11/seahorse-pkcs11-object.c \
		pkcs11/seahorse-pkcs11-operations.c
	# Do not mess with CFLAGS with USE="debug"
	sed -e '/CFLAGS="$CFLAGS -g -O0/d' \
		-e 's/-Werror//' \
		-i configure.in configure || die "sed failed"
}

src_install() {
	gnome2_src_install
	find "${ED}" -name "*.la" -delete || die "remove of la files failed"
}

pkg_postinst() {
	gnome2_pkg_postinst
	if ! has app-crypt/seahorse-plugins; then
		einfo "The seahorse-agent tool has been moved to app-crypt/seahorse-plugins"
		einfo "Use that if you want seahorse to manage your terminal SSH keys"
	fi
}
