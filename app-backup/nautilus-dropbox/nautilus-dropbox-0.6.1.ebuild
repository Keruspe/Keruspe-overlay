# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2 eutils

DESCRIPTION="Store, Sync and Share Files Online"
HOMEPAGE="http://www.getdropbox.com/"
SRC_URI="http://www.getdropbox.com/download?dl=packages/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

RDEPEND=">=gnome-base/nautilus-2.16
	>=dev-libs/glib-2.14
	dev-python/pygtk
	>=x11-libs/gtk+-2.12
	>=x11-libs/libnotify-0.4.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-python/docutils"

DOCS="AUTHORS ChangeLog NEWS README"
G2CONF="${G2CONF} $(use_enable debug)"

pkg_setup () {
	enewgroup dropbox
}

src_install () {
	gnome2_src_install

	local extensiondir="$(pkg-config --variable=extensiondir libnautilus-extension)"
	fowners root:dropbox "${extensiondir}"/libnautilus-dropbox.{a,la,so}
	fperms o-rwx "${extensiondir}"/libnautilus-dropbox.{a,la,so}
}

pkg_postinst () {
	gnome2_pkg_postinst

	elog "Add any users who wish to have access to the dropbox nautilus"
	elog "plugin to the group 'dropbox'."
	elog
	elog "If you've installed old version, Remove \${HOME}/.dropbox-dist first."
	elog
	elog " $ rm -rf \${HOME}/.dropbox-dist"
	elog " $ dropbox start -i"
}
