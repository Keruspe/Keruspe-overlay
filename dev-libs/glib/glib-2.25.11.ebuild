# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools gnome.org libtool eutils flag-o-matic

DESCRIPTION="The GLib library of C routines"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc fam hardened introspection selinux static-libs test xattr"

RDEPEND="virtual/libiconv
	xattr? ( sys-apps/attr )
	fam? ( virtual/fam )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.16
	>=sys-devel/gettext-0.11
	doc? (
		>=dev-libs/libxslt-1.0
		>=dev-util/gtk-doc-1.11
		~app-text/docbook-xml-dtd-4.1.2 )
	test? ( >=sys-apps/dbus-1.2.14 )"
PDEPEND="introspection? ( dev-libs/gobject-introspection )"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.18.1-workaround-gio-test-failure-without-userpriv.patch"
	epatch "${FILESDIR}"/${PN}-2.12.12-fbsd.patch
	epatch "${FILESDIR}/${PN}-2.24-punt-python-check.patch"
	epatch "${FILESDIR}/${PN}-2.24-assert-test-failure.patch"
	sed 's:^\(.*"/desktop-app-info/delete".*\):/*\1*/:' \
		-i "${S}"/gio/tests/desktop-app-info.c || die "sed failed"
	eautoreconf
	[[ ${CHOST} == *-freebsd* ]] && elibtoolize
	epunt_cxx
}

src_configure() {
	local myconf
	use debug && myconf="--enable-debug"
	econf ${myconf} \
		  $(use_enable xattr) \
		  $(use_enable doc man) \
		  $(use_enable doc gtk-doc) \
		  $(use_enable fam) \
		  $(use_enable selinux) \
		  $(use_enable static-libs static) \
		  --enable-regex \
		  --with-pcre=internal \
		  --with-threads=posix
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
	rm -f "${D}/usr/lib/charset.alias"
	rm -rf "${D}/usr/share/gdb/" "${D}/usr/share/glib-2.0/gdb/"
	dodoc AUTHORS ChangeLog* NEWS* README || die "dodoc failed"
	insinto /usr/share/bash-completion
	newins "${D}/etc/bash_completion.d/gdbus-bash-completion.sh" gdbus || die
	rm -rf "${D}/etc"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	export XDG_CONFIG_DIRS=/etc/xdg
	export XDG_DATA_DIRS=/usr/local/share:/usr/share
	export XDG_DATA_HOME="${T}"
	emake check || die "tests failed"
}

pkg_preinst() {
	if use introspection && has_version "${CATEGORY}/${PN}"; then
		if ! has_version "=${CATEGORY}/${PF}"; then
			ewarn "You must rebuild gobject-introspection so that the installed"
			ewarn "typelibs and girs are regenerated for the new APIs in glib"
		fi
	fi
}
