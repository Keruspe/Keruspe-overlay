# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit autotools linux-info systemd git-2

DESCRIPTION="Daemon providing interfaces to work with storage devices"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/udisks"
EGIT_REPO_URI="git://anongit.freedesktop.org/udisks"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="
	dev-libs/gobject-introspection
	>=sys-fs/udev-171-r1[gudev]
	>=dev-libs/glib-2.31.13
	>=sys-apps/dbus-1.4.0
	>=dev-libs/dbus-glib-0.92
	>=sys-auth/polkit-0.97
	>=sys-block/parted-1.8.8
	>=sys-fs/lvm2-2.02.66
	>=dev-libs/libatasmart-0.14"
RDEPEND="${COMMON_DEPEND}
	virtual/eject"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/intltool-0.40.0
	dev-util/gtk-doc
	dev-util/pkgconfig"

RESTRICT="test" # FIXME: dbus environment and sudo problems

pkg_setup() {
	if use amd64 || use x86; then
		CONFIG_CHECK="~USB_SUSPEND ~!IDE"
		linux-info_pkg_setup
	fi
}

src_prepare() {
	gtkdocize
	intltoolize --force --automake --copy
	eautoreconf
}

src_configure() {
	# device-mapper -> lvm2 -> is always a depend, force enabled
	econf \
		--localstatedir="${EPREFIX}"/var \
		--disable-static \
		--enable-man-pages \
		$(systemd_with_unitdir) \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html
}

src_install() {
	emake DESTDIR="${D}" slashsbindir=/usr/sbin install #398081
	dodoc AUTHORS HACKING NEWS README

	find "${ED}" -name '*.la' -exec rm -f {} +

	keepdir /media
	keepdir /var/lib/udisks #383091
}
