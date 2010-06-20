# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils multilib versionator

PV_MAJ_MIN=$(get_version_component_range '1-2')

DESCRIPTION="Streaming media framework"
HOMEPAGE="http://gstreamer.sourceforge.net"
SRC_URI="http://${PN}.freedesktop.org/src/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT=${PV_MAJ_MIN}
KEYWORDS="~amd64 ~x86"
IUSE="introspection nls test"

RDEPEND=">=dev-libs/glib-2.18:2
	dev-libs/libxml2
	!<media-libs/gst-plugins-base-0.10.26"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	introspection? ( dev-libs/gobject-introspection )
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch ${FILESDIR}/0001-introspection-Fix-with-recent-gobject-introspection.patch
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--disable-dependency-tracking \
		$(use_enable nls) \
		--disable-valgrind \
		--disable-examples \
		--enable-check \
		$(use_enable introspection) \
		$(use_enable test tests) \
		--with-package-name="GStreamer ebuild for Gentoo" \
		--with-package-origin="http://packages.gentoo.org/package/media-libs/gstreamer"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS MAINTAINERS README RELEASE

	cd "${D}"/usr/bin
	local gst_bins
	for gst_bins in $(ls *-${PV_MAJ_MIN}); do
		rm -f ${gst_bins/-${PV_MAJ_MIN}/}
	done
}
