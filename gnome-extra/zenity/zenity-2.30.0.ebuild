# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2

DESCRIPTION="Tool to display dialogs from the commandline and shell scripts"
HOMEPAGE="http://www.gnome.org/"
LICENSE="LGPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+compat libnotify"

RDEPEND=">=x11-libs/gtk+-2.15.2
	>=dev-libs/glib-2.8
	compat? ( >=dev-lang/perl-5 )
	libnotify? ( >=x11-libs/libnotify-0.4.1 )"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.14
	>=dev-util/pkgconfig-0.9
	>=app-text/gnome-doc-utils-0.10.1
	>=gnome-base/gnome-common-2.12.0"

DOCS="AUTHORS ChangeLog HACKING NEWS README THANKS TODO"

G2CONF="${G2CONF}
	--disable-scrollkeeper
	$(use_enable libnotify)"

src_install() {
	gnome2_src_install
	if ! use compat; then
		rm "${D}/usr/bin/gdialog" || die "rm gdialog failed!"
	fi
}
