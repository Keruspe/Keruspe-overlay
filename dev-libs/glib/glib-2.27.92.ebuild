# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"

inherit autotools gnome.org libtool eutils flag-o-matic pax-utils python

DESCRIPTION="The GLib library of C routines"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc fam +introspection selinux static-libs test xattr"

RDEPEND="virtual/libiconv
	sys-libs/zlib
	xattr? ( sys-apps/attr )
	fam? ( virtual/fam )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.16
	>=sys-devel/gettext-0.11
	doc? (
		>=dev-libs/libxslt-1.0
		>=dev-util/gtk-doc-1.13
		~app-text/docbook-xml-dtd-4.1.2 )
	test? ( >=sys-apps/dbus-1.2.14 )"
PDEPEND="introspection? ( >dev-libs/gobject-introspection-0.10.0 )
	!<gnome-base/gvfs-1.6.5"

pkg_setup() {
	python_set_active_version 2

}

src_prepare() {
	if use ia64 ; then
		# Only apply for < 4.1
		local major=$(gcc-major-version)
		local minor=$(gcc-minor-version)
		if (( major < 4 || ( major == 4 && minor == 0 ) )); then
			epatch "${FILESDIR}/glib-2.10.3-ia64-atomic-ops.patch"
		fi
	fi

	# Don't fail gio tests when ran without userpriv, upstream bug 552912
	# This is only a temporary workaround, remove as soon as possible
	epatch "${FILESDIR}/${PN}-2.18.1-workaround-gio-test-failure-without-userpriv.patch"

	# Fix gmodule issues on fbsd; bug #184301
	epatch "${FILESDIR}"/${PN}-2.12.12-fbsd.patch

	# Don't check for python, hence removing the build-time python dep.
	# We remove the gdb python scripts in src_install due to bug 291328
	epatch "${FILESDIR}/${PN}-2.25-punt-python-check.patch"

	# Fix test failure when upgrading from 2.22 to 2.24, upstream bug 621368
	epatch "${FILESDIR}/${PN}-2.24-assert-test-failure.patch"

	# skip tests that require writing to /root/.dbus, upstream bug 631379
	#epatch "${FILESDIR}/${PN}-2.25-skip-tests-with-dbus-keyring.patch"

	# Do not try to remove files on live filesystem, upstream bug #619274
	sed 's:^\(.*"/desktop-app-info/delete".*\):/*\1*/:' \
		-i "${S}"/gio/tests/desktop-app-info.c || die "sed failed"

	if ! use test; then
		sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed failed"
	fi

	sed -e '/gsettings/d' \
		-i gio/tests/Makefile.{am,in} || die "sed gsettings failed"

	eautoreconf

	[[ ${CHOST} == *-freebsd* ]] && elibtoolize

	epunt_cxx
}

src_configure() {
	local myconf
	use debug && myconf="--enable-debug --disable-visibility"

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
	local f
	emake DESTDIR="${D}" install || die "Installation failed"

	# Do not install charset.alias even if generated, leave it to libiconv
	rm -f "${ED}/usr/lib/charset.alias"

	# Don't install gdb python macros, bug 291328
	rm -rf "${ED}/usr/share/gdb/" "${ED}/usr/share/glib-2.0/gdb/"

	emake README || die "emake README failed"
	dodoc AUTHORS ChangeLog* NEWS* README || die "dodoc failed"

	insinto /usr/share/bash-completion
	for f in gdbus gsettings; do
		newins "${ED}/etc/bash_completion.d/${f}-bash-completion.sh" ${f} || die
	done
	rm -rf "${ED}/etc"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	export XDG_CONFIG_DIRS=/etc/xdg
	export XDG_DATA_DIRS=/usr/local/share:/usr/share
	export G_DBUS_COOKIE_SHA1_KEYRING_DIR="${T}/temp"
	export XDG_DATA_HOME="${T}"

	# Related test is a bit nitpicking
	mkdir "$G_DBUS_COOKIE_SHA1_KEYRING_DIR/temp"
	chmod 0700  "$G_DBUS_COOKIE_SHA1_KEYRING_DIR/temp"

	# Hardened: gdb needs this, bug #338891
	if host-is-pax ; then
		pax-mark -mr "${S}"/tests/.libs/assert-msg-test \
			|| die "Hardened adjustment failed"
	fi

	emake check || die "tests failed"
}

pkg_preinst() {
	# Only give the introspection message if:
	# * The user has it enabled
	# * Has glib already installed
	# * Previous version was different from new version
	if use introspection && has_version "${CATEGORY}/${PN}"; then
		if ! has_version "=${CATEGORY}/${PF}"; then
			ewarn "You must rebuild gobject-introspection so that the installed"
			ewarn "typelibs and girs are regenerated for the new APIs in glib"
		fi
	fi
}

pkg_postinst() {
	# Inform users about possible breakage when updating glib and not dbus-glib, bug #297483
	if has_version dev-libs/dbus-glib; then
		ewarn "If you experience a breakage after updating dev-libs/glib try"
		ewarn "rebuilding dev-libs/dbus-glib"
	fi
}
