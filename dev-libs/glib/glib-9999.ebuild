# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools git gnome.org libtool eutils flag-o-matic

DESCRIPTION="The GLib library of C routines"
HOMEPAGE="http://www.gtk.org/"

EGIT_REPO_URI="git://git.gnome.org/${PN}"
EGIT_BRANCH="glib-2.26"
SRC_URI=""

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc fam hardened +introspection selinux static-libs test xattr"

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
# XXX: Consider adding test? ( sys-devel/gdb ); assert-msg-test tries to use it

src_unpack() {
	git_src_unpack
}

src_prepare() {
	if use ppc64 && use hardened ; then
		replace-flags -O[2-3] -O1
		epatch "${FILESDIR}/glib-2.6.3-testglib-ssp.patch"
	fi

	if use ia64 ; then
		# Only apply for < 4.1
		local major=$(gcc-major-version)
		local minor=$(gcc-minor-version)
		if (( major < 4 || ( major == 4 && minor == 0 ) )); then
			epatch "${FILESDIR}/glib-2.10.3-ia64-atomic-ops.patch"
		fi
	fi

	# Don't check for python, hence removing the build-time python dep.
	# We remove the gdb python scripts in src_install due to bug 291328
	sed -i '/AM_PATH_PYTHON/d' configure.ac

	gtkdocize
	# Needed for the punt-python-check patch.
	eautoreconf

	[[ ${CHOST} == *-freebsd* ]] && elibtoolize

	epunt_cxx
}

src_configure() {
	local myconf

	# Building with --disable-debug highly unrecommended.  It will build glib in
	# an unusable form as it disables some commonly used API.  Please do not
	# convert this to the use_enable form, as it results in a broken build.
	# -- compnerd (3/27/06)
	use debug && myconf="--enable-debug"

	# Always use internal libpcre, bug #254659
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
	rm -f "${D}/usr/lib/charset.alias"

	# Don't install gdb python macros, bug 291328
	rm -rf "${D}/usr/share/gdb/" "${D}/usr/share/glib-2.0/gdb/"

	insinto /usr/share/bash-completion
	for f in gdbus gsettings; do
		newins "${D}/etc/bash_completion.d/${f}-bash-completion.sh" ${f} || die
	done
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
