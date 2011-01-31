# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/evolution-data-server/evolution-data-server-2.32.1-r1.ebuild,v 1.4 2011/01/15 19:55:02 nirbheek Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit autotools db-use eutils flag-o-matic gnome2 versionator virtualx

DESCRIPTION="Evolution groupware backend"
HOMEPAGE="http://www.gnome.org/projects/evolution/"

LICENSE="LGPL-2 BSD DB"
SLOT="0"
IUSE="doc +introspection ipv6 ldap kerberos ssl +weather"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-solaris"
fi

RDEPEND=">=dev-libs/glib-2.25.12:2
	>=x11-libs/gtk+-2.22:2
	>=gnome-base/gconf-2
	>=dev-db/sqlite-3.5
	>=dev-libs/libgdata-0.7
	>=gnome-base/gnome-keyring-2.20.1
	>=dev-libs/libical-0.43
	>=net-libs/libsoup-2.4:2.4
	>=dev-libs/libxml2-2
	>=sys-libs/db-4
	sys-libs/zlib
	virtual/libiconv
	introspection? ( >=dev-libs/gobject-introspection-0.9.12 )
	kerberos? ( virtual/krb5 )
	ldap? ( >=net-nds/openldap-2 )
	ssl? (
		>=dev-libs/nspr-4.4
		>=dev-libs/nss-3.9 )
	weather? ( >=dev-libs/libgweather-2.25.4:2 )
"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35.5
	sys-devel/bison
	>=gnome-base/gnome-common-2
	>=dev-util/gtk-doc-am-1.9
	>=sys-devel/gettext-0.17
	doc? ( >=dev-util/gtk-doc-1.9 )"
# eautoreconf needs:
#	>=gnome-base/gnome-common-2
#	>=dev-util/gtk-doc-am-1.9

pkg_setup() {
	DOCS="ChangeLog MAINTAINERS NEWS TODO"
	G2CONF="${G2CONF}
		$(use_enable ipv6)
		$(use_with kerberos krb5 /usr)
		$(use_with ldap openldap)
		$(use_enable ssl ssl)
		$(use_enable ssl smime)
		$(use_enable weather)
		--disable-gtk3
		--enable-calendar
		--enable-nntp
		--enable-largefile
		--with-libdb=/usr"
}

src_prepare() {
	# WTF: libebook-1.2 links against system libcamel-1.2
	#      libedata-book-1.2 links against system libebackend-1.2
	gnome2_src_prepare

	# Adjust to gentoo's /etc/service
	epatch "${FILESDIR}/${PN}-2.31-gentoo_etc_services.patch"

	# GNOME bug 611353 (skips failing test atm)
	# XXX: uncomment when there's a proper fix
	#epatch "${FILESDIR}/e-d-s-camel-skip-failing-test.patch"

	# GNOME bug 621763 (skip failing test-ebook-stress-factory--fifo)
	#sed -e 's/\(SUBDIRS =.*\)ebook/\1/' \
	#	-i addressbook/tests/Makefile.{am,in} \
	#	|| die "failing test sed 1 failed"

	# /usr/include/db.h is always db-1 on FreeBSD
	# so include the right dir in CPPFLAGS
	append-cppflags "-I$(db_includedir)"

	# FIXME: Fix compilation flags crazyness
	sed 's/^\(AM_CPPFLAGS="\)$WARNING_FLAGS/\1/' \
		-i configure.ac configure || die "sed 3 failed"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

src_install() {
	gnome2_src_install
	find "${ED}" -name "*.la" -delete || die "la files removal failed"

	if use ldap; then
		MY_MAJORV=$(get_version_component_range 1-2)
		insinto /etc/openldap/schema
		doins "${FILESDIR}"/calentry.schema || die "doins failed"
		dosym /usr/share/${PN}-${MY_MAJORV}/evolutionperson.schema /etc/openldap/schema/evolutionperson.schema
	fi
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	unset ORBIT_SOCKETDIR
	unset SESSION_MANAGER
	export XDG_DATA_HOME="${T}"
	unset DISPLAY
	Xemake check || die "Tests failed."
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use ldap; then
		elog ""
		elog "LDAP schemas needed by evolution are installed in /etc/openldap/schema"
	fi
}
