# Copyright 1999-2010 Gentoo Foundation
# Copyright 2009-2010 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="A Telepathy client that handles channels of type 'StreamedMedia'"
HOMEPAGE="http://telepathy.freedesktop.org/"
SRC_URI="http://telepathy.freedesktop.org/releases/stream-engine/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~sparc ~x86"
IUSE="debug v4l v4l2 xv alsa esd oss gnome pulseaudio"

DEPEND=">=dev-libs/glib-2.4
	dev-libs/libxml2
	>=media-libs/farsight-0.1.27
	=media-libs/gst-plugins-base-0.10*
	>=media-libs/gstreamer-0.10.17
	>=net-libs/telepathy-glib-0.7.6
	>=dev-libs/dbus-glib-0.71
	x11-libs/libX11"

RDEPEND="${DEPEND}
	=media-plugins/gst-plugins-x-0.10*
	v4l? ( =media-plugins/gst-plugins-v4l-0.10* )
	v4l2? ( =media-plugins/gst-plugins-v4l2-0.10* )
	xv? ( =media-plugins/gst-plugins-xvideo-0.10* )
	alsa? ( =media-plugins/gst-plugins-alsa-0.10* )
	esd? ( =media-plugins/gst-plugins-esd-0.10* )
	oss? ( =media-plugins/gst-plugins-oss-0.10* )
	gnome? ( =media-plugins/gst-plugins-gconf-0.10* )
	pulseaudio? ( || (
		>=media-libs/gst-plugins-good-0.10.9
		media-plugins/gst-plugins-pulse ) )"

src_configure() {
	econf \
		$(use_enable debug backtrace) \
		|| die "econf failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake failed"
	dodoc TODO ChangeLog
}
