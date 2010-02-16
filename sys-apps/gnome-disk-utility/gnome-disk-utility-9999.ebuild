# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
GCONF_DEBUG="no"

inherit autotools git gnome2

DESCRIPTION="Disk Utility for GNOME using devicekit-disks"
HOMEPAGE="http://git.gnome.org/cgit/gnome-disk-utility/"
SRC_URI=""
EGIT_BRANCH="master"
EGIT_REPO_URI="git://git.gnome.org/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gnome-keyring +nautilus nls"

RDEPEND="
	>=dev-libs/glib-2.16
	>=dev-libs/dbus-glib-0.71
	>=dev-libs/libunique-1.0
	>=x11-libs/gtk+-2.17
	>=dev-libs/libatasmart-0.14
	>=gnome-base/gnome-keyring-2.22
	>=x11-libs/libnotify-0.3
	sys-apps/udisks

	nautilus? ( >=gnome-base/nautilus-2.24 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	app-text/gnome-doc-utils
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-1.3"
DOCS="AUTHORS NEWS README TODO"

WANT_AUTOMAKE="1.9"

src_unpack() {
    git_src_unpack
}

src_prepare() {
    gnome2_src_prepare
    gtkdocize || die "gtkdocize failed"
    gnome-doc-prepare
	intltoolize --force --copy --automake || die "intltoolize failed"
    eautoreconf
}

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable gnome-keyring)
		$(use_enable nautilus)
		$(use_enable nls)"
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}
