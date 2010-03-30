# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit db-use eutils flag-o-matic gnome2 versionator

DESCRIPTION="Evolution groupware backend"
HOMEPAGE="http://www.gnome.org/projects/evolution/"
LICENSE="LGPL-2 BSD DB"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc ipv6 kerberos gnome-keyring ldap nntp ssl"

RDEPEND=">=dev-libs/glib-2.16.1
	>=x11-libs/gtk+-2.14
	>=gnome-base/gconf-2
	>=dev-db/sqlite-3.5
	>=dev-libs/libxml2-2
	>=net-libs/libsoup-2.4
	>=dev-libs/libgweather-2.25.4
	>=dev-libs/libical-0.43
	>=dev-libs/dbus-glib-0.6
	sys-devel/bison
	gnome-keyring? ( >=gnome-base/gnome-keyring-2.20.1 )
	>=sys-libs/db-4
	virtual/libiconv
	ssl? (
		>=dev-libs/nspr-4.4
		>=dev-libs/nss-3.9 )
	sys-libs/zlib

	ldap? ( >=net-nds/openldap-2.0 )
	kerberos? ( virtual/krb5 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35.5
	>=gnome-base/gnome-common-2
	>=dev-util/gtk-doc-am-1.9
	doc? ( >=dev-util/gtk-doc-1.9 )"

DOCS="ChangeLog MAINTAINERS NEWS TODO"

G2CONF="${G2CONF}
	$(use_with kerberos krb5 /usr)
	$(use_with ldap openldap)
	$(use_enable gnome-keyring)
	$(use_enable ipv6)
	$(use_enable nntp)
	$(use_enable ssl ssl)
	$(use_enable ssl smime)
	--with-weather
	--enable-largefile
	--with-libdb=/usr/$(get_libdir)"

src_prepare() {
	gnome2_src_prepare
	
	epatch "${FILESDIR}/${PN}-2.28.0-gentoo_etc_services.patch"
	epatch "${FILESDIR}/${PN}-1.8.0-camel-rewind.patch"
	epatch "${FILESDIR}/e-d-s-camel-skip-failing-test.patch"

	if use doc; then
		sed "/^TARGET_DIR/i \GTKDOC_REBASE=/usr/bin/gtkdoc-rebase" \
			-i gtk-doc.make || die "sed 1 failed"
	else
		sed "/^TARGET_DIR/i \GTKDOC_REBASE=$(type -P true)" \
			-i gtk-doc.make || die "sed 2 failed"
	fi

	append-cppflags "-I$(db_includedir)"

	sed 's/CFLAGS="$CFLAGS $WARNING_FLAGS"//' \
		-i configure.ac configure || die "sed 3 failed"

	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "intltool rules fix failed"

}

src_install() {
	gnome2_src_install

	if use ldap; then
		MY_MAJORV=$(get_version_component_range 1-2)
		insinto /etc/openldap/schema
		doins "${FILESDIR}"/calentry.schema || die "doins failed"
		dosym /usr/share/${PN}-${MY_MAJORV}/evolutionperson.schema /etc/openldap/schema/evolutionperson.schema
	fi
}

src_test() {
	emake check || die "Tests failed."
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use ldap; then
		elog ""
		elog "LDAP schemas needed by evolution are installed in /etc/openldap/schema"
	fi
}
