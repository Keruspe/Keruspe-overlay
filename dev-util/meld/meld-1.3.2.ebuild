# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils gnome2 python

DESCRIPTION="A graphical (GNOME 2) diff and merge tool"
HOMEPAGE="http://meld.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-lang/python-2.4
	>=gnome-base/libglade-2
	>=dev-python/pygtk-2.8.0
	>=dev-python/pygobject-2.8"

DEPEND="${RDEPEND}
	dev-util/intltool
	app-text/scrollkeeper"

DOCS="AUTHORS NEWS help/ChangeLog"

src_prepare() {	
	gnome2_src_prepare
	sed -e 's:/usr/local:/usr:' \
		-e "s:\$(prefix)/lib:\$(prefix)/$(get_libdir):" \
		-i INSTALL || die "sed 1 failed"
	
	sed -e "s:\$(docdir)/meld:\$(docdir)/${PF}:" \
		-i INSTALL || die "sed 2 failed"

	sed -e '/$(PYTHON) .* .import compileall;/s/\t/&#/g' \
		-i Makefile || die "sed 3 failed"

	sed -e '/scrollkeeper-update/s/\t/&#/' \
		-i help/*/Makefile || die "sed 4 failed"

	strip-linguas -i "${S}/po"
	local mylinguas=""
	for x in ${LINGUAS}; do
		mylinguas="${mylinguas} ${x}.po"
	done

	if [ -n "${mylinguas}" ]; then
		sed -e "s/PO:=.*/PO:=${mylinguas}/" \
			-i po/Makefile || die "sed 5 failed"
	fi
}

src_configure() {
	:
}

src_compile() {
	emake || die "make failed"
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/meld
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/meld
}
