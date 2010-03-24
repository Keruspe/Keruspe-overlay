# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="GUI for iPod using GTK2"
HOMEPAGE="http://gtkpod.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/${PN}/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2 FDL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac curl flac mp3 nls ogg"

RDEPEND=">=x11-libs/gtk+-2.8
	>=media-libs/libid3tag-0.15
	>=gnome-base/libglade-2.4
	>=media-libs/libgpod-0.7.92
	>=net-misc/curl-7.10
	mp3? ( media-sound/lame
		media-sound/id3v2 )
	aac? ( media-libs/libmp4v2 )
	ogg? ( media-libs/libvorbis
		media-sound/vorbis-tools )
	flac? ( media-libs/flac )"
DEPEND="${RDEPEND}
	curl? ( net-misc/curl )
	dev-util/pkgconfig
	sys-devel/flex
	nls? ( dev-util/intltool
		sys-devel/gettext )"

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with curl) \
		$(use_with ogg) \
		$(use_with flac)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TROUBLESHOOTING *.txt
}
