# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2 eutils mono libtool

DESCRIPTION="Utilities for creating and parsing messages using MIME"
HOMEPAGE="http://spruce.sourceforge.net/gmime/"
SLOT="2.6"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="doc mono"

RDEPEND=">=dev-libs/glib-2.12
	sys-libs/zlib
	mono? (
		dev-lang/mono
		>=dev-dotnet/gtk-sharp-2.4.0 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? (
		>=dev-util/gtk-doc-1.0
		app-text/docbook-sgml-utils )
	mono? ( dev-dotnet/gtk-sharp-gapi )"

DOCS="AUTHORS ChangeLog COPYING INSTALL NEWS PORTING README TODO doc/html/"

src_prepare() {
	if use doc ; then
		sed -i -e 's:db2html:docbook2html -o gmime-tut:g' \
			docs/tutorial/Makefile.am docs/tutorial/Makefile.in \
			|| die "sed failed (1)"
		sed -i -e 's!\<\(tmpl-build.stamp\): !\1 $(srcdir)/tmpl/*.sgml: !' \
			gtk-doc.make docs/reference/Makefile.in || die "sed failed (3)"
	fi

	sed -i -e 's:^libdir.*:libdir=@libdir@:' \
		   -e 's:^prefix=:exec_prefix=:' \
		   -e 's:prefix)/lib:libdir):' \
		mono/gmime-sharp-2.4.pc.in mono/Makefile.{am,in} || die "sed failed (2)"

	elibtoolize
}

src_compile() {
	econf $(use_enable mono) $(use_enable doc gtk-doc)
	MONO_PATH="${S}" emake || die "emake failed"
}

src_install() {
	emake GACUTIL_FLAGS="/root '${D}/usr/$(get_libdir)' /gacdir /usr/$(get_libdir) /package ${PN}" \
		DESTDIR="${D}" install || die "installation failed"

	if use doc ; then
		insinto /usr/share/doc/${PF}/tutorial
		doins docs/tutorial/html/*
	fi

	mv "${D}/usr/bin/uuencode" "${D}/usr/bin/gmime-uuencode-${SLOT}"
	mv "${D}/usr/bin/uudecode" "${D}/usr/bin/gmime-uudecode-${SLOT}"
}
