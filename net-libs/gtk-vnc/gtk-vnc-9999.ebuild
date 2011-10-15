# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils gnome2-live python

DESCRIPTION="VNC viewer widget for GTK"
HOMEPAGE="http://live.gnome.org/gtk-vnc"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="examples +gtk3 +introspection python sasl"

COMMON_DEPEND=">=dev-libs/glib-2.10:2
	>=net-libs/gnutls-1.4
	>=x11-libs/cairo-1.2
	x11-libs/libX11
	>=x11-libs/gtk+-3.0.0:3
	introspection? ( >=dev-libs/gobject-introspection-0.9.4 )
	python? ( >=dev-python/pygtk-2:2 )
	sasl? ( dev-libs/cyrus-sasl )"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	dev-perl/Text-CSV
	dev-util/pkgconfig
	sys-devel/gettext
	>=dev-util/intltool-0.40"

pkg_setup() {
	python_set_active_version 2
	MAKEOPTS+=" -j1"
}

src_prepare() {
	python_convert_shebangs -r 2 .
	mkdir m4
	sed -i s/pygtk-codegen/pygobject-codegen/ src/Makefile.am
	intltoolize --force --copy --automake || die
	eautoreconf
}

src_configure() {
	# Python support is via gobject-introspection
	# Ex: from gi.repository import GtkVnc
	econf $(use_with examples) \
		$(use_enable introspection) \
		$(use_with sasl) \
		--with-coroutine=gthread \
		--without-libview \
		--disable-static \
		--with-python=no \
		--with-gtk=3.0
}

src_install() {
	dodoc AUTHORS NEWS README || die
	gnome2_src_install
	python_clean_installation_image
	# Remove .la files
	find "${ED}" -name '*.la' -exec rm -f '{}' + || die
}
