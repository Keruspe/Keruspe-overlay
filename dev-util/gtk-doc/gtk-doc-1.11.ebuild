# Copyright 1999-2010 Gentoo Foundation
# Copyright 2009-2010 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils elisp-common gnome2

EAPI="2"

DESCRIPTION="GTK+ Documentation Generator"
HOMEPAGE="http://www.gtk.org/gtk-doc/"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="debug doc emacs"

RDEPEND=">=dev-libs/glib-2.6
	>=dev-lang/perl-5.6
	>=app-text/openjade-1.3.1
	dev-libs/libxslt
	>=dev-libs/libxml2-2.3.6
	~app-text/docbook-xml-dtd-4.3
	app-text/docbook-xsl-stylesheets
	~app-text/docbook-sgml-dtd-3.0
	>=app-text/docbook-dsssl-stylesheets-1.40
	emacs? ( virtual/emacs )"

DEPEND="${RDEPEND}
	~dev-util/gtk-doc-am-${PV}
	>=dev-util/pkgconfig-0.19
	>=app-text/gnome-doc-utils-0.3.2"

SITEFILE=61${PN}-gentoo.el

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README TODO"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.8-emacs-keybindings.patch"
	epatch "${FILESDIR}/${PN}-1.10-no-m4.patch"
	epatch "${FILESDIR}/${P}-fix-index-id-gen.patch"
	epatch "${FILESDIR}/${P}-tests-fixes.patch"
	epatch "${FILESDIR}/${P}-quote-filenames-with-space.patch"
	gnome2_src_prepare
}

src_compile() {
	gnome2_src_compile

	use emacs && elisp-compile tools/gtk-doc.el
}

src_install() {
	gnome2_src_install

	if use doc; then
		docinto doc
		dodoc doc/*
		docinto examples
		dodoc examples/*
	fi

	if use emacs; then
		elisp-install ${PN} tools/gtk-doc.el*
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		elog "gtk-doc does no longer define global key bindings for Emacs."
		elog "You may set your own key bindings for \"gtk-doc-insert\" and"
		elog "\"gtk-doc-insert-section\" in your ~/.emacs file."
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
