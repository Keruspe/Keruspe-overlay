# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Shared library to access the contents of an iPod"
HOMEPAGE="http://www.gtkpod.org/libgpod.html"
SRC_URI="http://downloads.sourceforge.net/project/gtkpod/${PN}/${P/2/x}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gtk hal iphone +nls python test +udev +xml"

RDEPEND=">=dev-libs/glib-2.18
	sys-apps/sg3_utils
	hal? ( sys-apps/hal )
	gtk? ( >=x11-libs/gtk+-2.6 )
	python? ( >=dev-lang/python-2.5
		>=media-libs/mutagen-1.8
		>=dev-python/pygobject-2.8 )
	test? ( media-libs/taglib )"
DEPEND="${RDEPEND}
	python? ( >=dev-lang/swig-1.3.24 )
	xml? ( dev-libs/libxml2 )
	nls? ( dev-util/intltool
		sys-devel/gettext )
	udev? ( sys-fs/udev )
	iphone? ( app-pda/libimobiledevice )
	dev-util/pkgconfig
	dev-util/gtk-doc
	dev-libs/libxslt"

src_configure() {
	econf \
		$(use_with hal) \
		$(use_enable nls) \
		$(use_enable xml libxml) \
		$(use_enable gtk gdk-pixbuf) \
		$(use_enable python pygobject) \
		$(use_enable udev) \
		$(use_with python) \
		$(use_with iphone libimobiledevice)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README TROUBLESHOOTING AUTHORS NEWS README.SysInfo
}
