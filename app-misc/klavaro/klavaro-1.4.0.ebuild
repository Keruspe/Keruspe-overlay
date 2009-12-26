# Copyright 1999-2009 Gentoo Foundation
# Copyright 2009 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Another free touch typing tutor program"
HOMEPAGE="http://klavaro.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-misc/curl
	x11-libs/gtkdatabox
	x11-libs/libsexy"

DEPEND="${RDEPEND}
	sys-devel/gettext"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	make_desktop_entry klavaro Klavaro "" Education
	dodoc AUTHORS ChangeLog NEWS README TODO || die "dodoc failed"
}
