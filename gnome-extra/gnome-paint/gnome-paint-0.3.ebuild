# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit gnome2

DESCRIPTION="A simple, easy to use paint program for GNOME"
HOMEPAGE="http://code.google.com/p/gnome-paint/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.16:2"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i s/GTK_WIDGET_STATE/gtk_widget_get_state/g ${S}/src/cv_resize.c
	sed -i s/GTK_WIDGET_STATE/gtk_widget_get_state/g ${S}/src/cv_drawing.c
}
