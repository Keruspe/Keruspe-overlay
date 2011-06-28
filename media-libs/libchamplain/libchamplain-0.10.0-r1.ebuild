# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2

DESCRIPTION="Clutter based world map renderer"
HOMEPAGE="http://blog.pierlux.com/projects/libchamplain/en/"

LICENSE="LGPL-2"
SLOT="0.10"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc +gtk +introspection vala"

REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.16:2
	>=x11-libs/cairo-1.4
	>=media-libs/clutter-1.2:1.0[introspection?]
	>=media-libs/memphis-0.2.1:0.2[introspection?]
	>=net-libs/libsoup-gnome-2.4.1:2.4
	dev-db/sqlite:3
	gtk? (
		>=x11-libs/gtk+-2.90:3[introspection?]
		>=media-libs/clutter-gtk-0.90:1.0 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.3 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.9 )
	vala? ( dev-lang/vala:0.12[vapigen] )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	# Vala demos are only built, so just disable them
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-static
		--disable-maemo
		--disable-vala-demos
		--enable-memphis
		VAPIGEN=$(type -p vapigen-0.12)
		$(use_enable debug)
		$(use_enable gtk)
		$(use_enable introspection)
		$(use_enable vala)"
}

src_prepare() {
	# Fix documentation slotability
	sed -e "s/^DOC_MODULE.*/DOC_MODULE = ${PN}-${SLOT}/" \
		-i docs/reference/Makefile.{am,in} || die "sed (1) failed"
	sed -e "s/^DOC_MODULE.*/DOC_MODULE = ${PN}-gtk-${SLOT}/" \
		-i docs/reference-gtk/Makefile.{am,in} || die "sed (2) failed"
	mv "${S}"/docs/reference/${PN}{,-${SLOT}}-docs.sgml || die "mv (1) failed"
	mv "${S}"/docs/reference-gtk/${PN}-gtk{,-${SLOT}}-docs.sgml || die "mv (1) failed"

	sed -i 's/ clutter-1.0/ clutter-1.0 --pkg pangocairo/' champlain/Makefile.in

	gnome2_src_prepare
}
