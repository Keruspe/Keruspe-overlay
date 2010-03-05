# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils gnome2

DESCRIPTION="The Eye of GNOME image viewer"
HOMEPAGE="http://www.gnome.org/projects/eog/"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="dbus doc exif lcms python xmp"

RDEPEND=">=x11-libs/gtk+-2.15.2
	>=dev-libs/glib-2.15.3
	>=dev-libs/libxml2-2
	>=gnome-base/gconf-2.5.90
	>=gnome-base/gnome-desktop-2.25.1
	>=x11-themes/gnome-icon-theme-2.19.1
	>=x11-misc/shared-mime-info-0.20

	dbus? ( >=dev-libs/dbus-glib-0.71 )
	exif? (
		>=media-libs/libexif-0.6.14
		media-libs/jpeg )
	lcms? ( media-libs/lcms )
	python? (
		>=dev-lang/python-2.3
		>=dev-python/pygobject-2.15.1
		>=dev-python/pygtk-2.13 )
	xmp? ( >=media-libs/exempi-2 )"

DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	sys-devel/gettext
	>=dev-util/intltool-0.40
	>=dev-util/pkgconfig-0.17
	doc? ( >=dev-util/gtk-doc-1.10 )"

DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README THANKS TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_with exif libjpeg)
		$(use_with exif libexif)
		$(use_with dbus)
		$(use_with lcms cms)
		$(use_enable python)
		$(use_with xmp)
		--enable-libtool-lock
		--disable-dependency-tracking
		--disable-scrollkeeper
		--disable-schemas-install"
}

src_install() {
	gnome2_src_install
	find "${D}" -name "*.la" -delete || die "remove of la files failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version x11-libs/gtk+:2[jpeg]; then
		ewarn "For JPEG file support to work, x11-libs/gtk+ must be rebuilt"
		ewarn "with the 'jpeg' USE flag enabled."
	fi

	if ! has_version x11-libs/gtk+:2[tiff]; then
		ewarn "For TIFF file support to work, x11-libs/gtk+ must be rebuilt"
		ewarn "with the 'tiff' USE flag enabled."
	fi
}
