# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2

MY_PN="glade3"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="GNOME GUI Builder"
HOMEPAGE="http://glade.gnome.org/"
SRC_URI="mirror://gnome/sources/${MY_PN}/${PVP[0]}.${PVP[1]}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="doc gnome python"

RDEPEND=">=dev-libs/glib-2.8.0
	>=x11-libs/gtk+-2.14.0
	>=dev-libs/libxml2-2.4
	gnome?	(
		>=gnome-base/libgnomeui-2.0
		>=gnome-base/libbonoboui-2.0 )
	python? ( >=dev-python/pygtk-2.10.0 )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.19
	sys-devel/gettext
	>=app-text/gnome-doc-utils-0.9
	doc? ( >=dev-util/gtk-doc-1.9 )
"

S="${WORKDIR}/${MY_P}"
DOCS="AUTHORS ChangeLog NEWS README TODO"

G2CONF="${G2CONF}
	--enable-libtool-lock
	--disable-scrollkeeper
	$(use_enable gnome)
	$(use_enable python)"

src_prepare() {
	gnome2_src_prepare

	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed 1 failed"
}
