# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Farsight2 is an audio/video conferencing framework specifically designed for Instant Messengers."
HOMEPAGE="http://farsight.freedesktop.org/"
SRC_URI="http://farsight.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="python test msn upnp"
SLOT="0"

COMMONDEPEND=">=media-libs/gstreamer-0.10.23
	>=media-libs/gst-plugins-base-0.10.23
	>=dev-libs/glib-2.16
	>=net-libs/libnice-0.0.9[gstreamer]
	python? (
		|| ( >=dev-python/pygobject-2.16 >=dev-python/pygtk-2.12 )
		>=dev-python/pygobject-2.12
		>=dev-python/gst-python-0.10.10 )
	upnp? ( net-libs/gupnp-igd )"

RDEPEND="${COMMONDEPEND}
	>=media-libs/gst-plugins-good-0.10.11
	>=media-libs/gst-plugins-bad-0.10.13
	|| ( >=media-libs/gst-plugins-good-0.10.16
		<media-libs/gst-plugins-bad-0.10.14 )
	msn? ( >=media-plugins/gst-plugins-mimic-0.10.14 )"

DEPEND="${COMMONDEPEND}
	test? ( media-plugins/gst-plugins-vorbis
		media-plugins/gst-plugins-speex )
	dev-util/pkgconfig"

src_configure() {
	plugins="fsrtpconference,funnel,rtcpfilter,videoanyrate"
	use msn && plugins="${plugins},fsmsnconference"
	econf $(use_enable python) \
		$(use_enable upnp gupnp) \
		--with-plugins=${plugins}
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS README ChangeLog
}

src_test()
{
	use msn || { einfo "Tests disabled without msn use flag"; return ;}
	if ! emake -j1 check; then
		hasq test $FEATURES && die "Make check failed. See above for details."
		hasq test $FEATURES || eerror "Make check failed. See above for details."
	fi
}
