# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils gnome2 flag-o-matic

DESCRIPTION="A versatile IDE for GNOME"
HOMEPAGE="http://www.anjuta.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug devhelp doc glade +sourceview subversion test"

RDEPEND=">=dev-libs/glib-2.16
	>=x11-libs/gtk+-2.14
	>=gnome-base/orbit-2.6
	>=gnome-base/gconf-2.12
	>=x11-libs/vte-0.13.1
	>=dev-libs/libxml2-2.4.23
	>=dev-libs/gdl-2.27.1
	>=dev-libs/libunique-1

	dev-libs/libxslt
	>=dev-lang/perl-5
	dev-perl/Locale-gettext
	sys-devel/autogen

	devhelp? (
		>=dev-util/devhelp-0.22
		>=net-libs/webkit-gtk-1 )
	glade? ( >=dev-util/glade-3.6.0 )
	subversion? (
		>=dev-util/subversion-1.5.0
		>=net-libs/neon-0.28.2
		>=dev-libs/apr-1
		>=dev-libs/apr-util-1 )
	sourceview? ( >=x11-libs/gtksourceview-2.4 )
	>=gnome-extra/libgda-4.1.6
	dev-util/ctags"
DEPEND="${RDEPEND}
	!!dev-libs/gnome-build
	>=sys-devel/gettext-0.14
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.20
	>=app-text/scrollkeeper-0.3.14-r2
	>=app-text/gnome-doc-utils-0.3.2
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.4 )
	test? (
		~app-text/docbook-xml-dtd-4.1.2
		~app-text/docbook-xml-dtd-4.5 )"

DOCS="AUTHORS ChangeLog FUTURE MAINTAINERS NEWS README ROADMAP THANKS TODO"

if ! use sourceview; then
	ewarn "You have disabled sourceview, which means you now have no editor"
fi

G2CONF="${G2CONF}
	--docdir=/usr/share/doc/${PF}
	$(use_enable debug)
	$(use_enable devhelp plugin-devhelp)
	$(use_enable glade plugin-glade)
	$(use_enable sourceview plugin-sourceview)
	$(use_enable subversion plugin-subversion)"

filter-flags -fomit-frame-pointer

src_install() {
	gnome2_src_install
	rm -rf "${D}"/usr/share/doc/${PN} || die "rm failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	ebeep 1
	elog ""
	elog "Some project templates may require additional development"
	elog "libraries to function correctly. It goes beyond the scope"
	elog "of this ebuild to provide them."
	epause 5
}
