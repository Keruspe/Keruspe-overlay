# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit toolchain-funcs gnome2

DESCRIPTION="An API documentation browser for GNOME 2"
HOMEPAGE="http://live.gnome.org/devhelp"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=gnome-base/gconf-2.6
	>=x11-libs/gtk+-2.10
	>=dev-libs/glib-2.10
	>=x11-libs/libwnck-2.10
	>=net-libs/webkit-gtk-1.1.13
	>=dev-libs/libunique-1"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README"

if [[ $(tc-getCC) == "icc" ]] ; then
	G2CONF="${G2CONF} --with-compile-warnings=no"
fi

src_prepare() {
	gnome2_src_prepare
	rm py-compile
	ln -s $(type -P true) py-compile
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed 1 failed"
	sed -e 's/-DG.*_SINGLE_INCLUDES//' \
		-e 's/-DG.*_DEPRECATED//' \
		-i src/Makefile.am src/Makefile.in || die "sed 2 failed"
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}
