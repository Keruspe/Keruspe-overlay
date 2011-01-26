# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit git autotools fdo-mime

WANT_AUTOMAKE=1.11

DESCRIPTION="A lightweight GTK+ based clipboard manager."
HOMEPAGE="http://parcellite.sourceforge.net/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/Keruspe/${PN}3"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=x11-libs/gtk+-2.99:3
	>=dev-libs/glib-2.14:2
	!x11-misc/parcellite:0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext
		dev-util/intltool )"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	mkdir m4
	cp $(type -p gettextize) "${T}/" || die "Could not copy gettextize"
	sed -i -e 's:read dummy < /dev/tty::' "${T}/gettextize"
	einfo "Running gettextize -f --no-changelog..."
	( "${T}/gettextize" -f --no-changelog > /dev/null ) || die "gettexize failed"
	intltoolize --copy --force --automake
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
