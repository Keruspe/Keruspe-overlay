# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils gnome2 multilib

DESCRIPTION="Internationalized text layout and rendering library"
HOMEPAGE="http://www.pango.org/"

LICENSE="LGPL-2 FTL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="X doc introspection test"

RDEPEND=">=dev-libs/glib-2.17.3
	>=media-libs/fontconfig-2.5.0
	media-libs/freetype:2
	>=x11-libs/cairo-1.7.6[X?]
	X? (
		x11-libs/libXrender
		x11-libs/libX11
		x11-libs/libXft )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	dev-util/gtk-doc-am
	doc? (
		>=dev-util/gtk-doc-1
		~app-text/docbook-xml-dtd-4.1.2
		x11-libs/libXft )
	introspection? (
		>=dev-libs/gobject-introspection-0.6.4
		!!dev-libs/gir-repository[pango] )
	test? (
		>=dev-util/gtk-doc-1
		~app-text/docbook-xml-dtd-4.1.2
		x11-libs/libXft )
	X? ( x11-proto/xproto )"

DOCS="AUTHORS ChangeLog* NEWS README THANKS"

function multilib_enabled() {
	has_multilib_profile || ( use x86 && [ "$(get_libdir)" = "lib32" ] )
}

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable introspection)
		$(use_with X x)"
}

src_prepare() {
	gnome2_src_prepare

	if multilib_enabled ; then
		epatch "${FILESDIR}/${PN}-1.26.0-lib64.patch"
	fi

	sed -e 's:TESTS = check.docs: TESTS = :g' \
		-i docs/Makefile.am || die "sed failed"

	eautoreconf
}

pkg_postinst() {
	if [ "${ROOT}" = "/" ] ; then
		einfo "Generating modules listing..."

		local PANGO_CONFDIR=

		if multilib_enabled ; then
			PANGO_CONFDIR="/etc/pango/${CHOST}"
		else
			PANGO_CONFDIR="/etc/pango"
		fi

		mkdir -p ${PANGO_CONFDIR}

		pango-querymodules > ${PANGO_CONFDIR}/pango.modules
	fi
}
