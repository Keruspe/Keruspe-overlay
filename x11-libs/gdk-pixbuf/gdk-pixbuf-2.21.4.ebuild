# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome.org flag-o-matic multilib libtool virtualx

DESCRIPTION="Image loading library for GTK+"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc introspection jpeg jpeg2k tiff test"

RDEPEND="
	>=dev-libs/glib-2.25.9
	>=media-libs/libpng-1.2.43-r2:0
	jpeg? ( >=media-libs/jpeg-6b-r9:0 )
	jpeg2k? ( media-libs/jasper )
	tiff? ( >=media-libs/tiff-3.9.2 )
	!<gnome-base/gail-1000
	!<x11-libs/gtk+-2.21.3:2
	!<x11-libs/gtk+-2.90.4:3"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=sys-devel/gettext-0.17
	x86-interix? (
		sys-libs/itx-bind
	)
	>=dev-util/gtk-doc-am-1.11
	doc? (
		>=dev-util/gtk-doc-1.11
		~app-text/docbook-xml-dtd-4.1.2 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )"

src_prepare() {
	replace-flags -O3 -O2
	strip-flags
	has_version ">dev-libs/gobject-introspection-0.6.14" && \
		for i in gdk-pixbuf/*.gir; do
			sed -i '/repository version=/s/1\.0/1.1/' ${i}
	done
	elibtoolize
}

src_configure() {
	local myconf="
		$(use_enable doc gtk-doc)
		$(use_with jpeg libjpeg)
		$(use_with jpeg2k libjasper)
		$(use_with tiff libtiff)
		$(use_enable introspection)
		--with-libpng"

	use debug && myconf="${myconf} --enable-debug=yes"

	econf ${myconf}
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "tests failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS NEWS* README* || die "dodoc failed"
}

pkg_postinst() {
	gdk-pixbuf-query-loaders > "${EROOT}usr/$(get_libdir)/gdk-pixbuf-2.0/2.10.0/loaders.cache"

	if [ -e "${EROOT}"usr/lib/gtk-2.0/2.*/loaders ]; then
		elog "You need to rebuild ebuilds that installed into" "${EROOT}"usr/lib/gtk-2.0/2.*/loaders
		elog "to do that you can use qfile from portage-utils:"
		elog "emerge -va1 \$(qfile -qC ${EPREFIX}/usr/lib/gtk-2.0/2.*/loaders)"
	fi
}
