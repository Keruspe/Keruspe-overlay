# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit eutils gnome2

DESCRIPTION="Archive manager for GNOME"
HOMEPAGE="http://fileroller.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="nautilus"
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
fi

RDEPEND=">=dev-libs/glib-2.25.5
	>=x11-libs/gtk+-2.91.1:3
	nautilus? ( >=gnome-base/nautilus-2.22.2 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40.0
	dev-util/pkgconfig
	app-text/gnome-doc-utils"

pkg_setup() {
	# TODO: PackageKit support
	G2CONF="${G2CONF}
		--disable-dependency-tracking
		--disable-scrollkeeper
		--disable-run-in-place
		--disable-static
		--disable-packagekit
		--disable-deprecations
		--disable-schemas-compile
		$(use_enable nautilus nautilus-actions)"
	DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README TODO"
}

src_prepare() {
	gnome2_src_prepare
	epatch "${FILESDIR}"/${PN}-2.10.3-use_bin_tar.patch
}

src_install() {
	gnome2_src_install
	if use nautilus; then
		find "${ED}"usr/$(get_libdir)/nautilus -name "*.la" -delete \
			|| die "la file removal failed"
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "${PN} is a frontend for several archiving utilities. If you want a"
	elog "particular achive format support, see ${HOMEPAGE}"
	elog "and install the relevant package."
	elog
	elog "for example:"
	elog "  7-zip   - app-arch/p7zip"
	elog "  ace     - app-arch/unace"
	elog "  arj     - app-arch/arj"
	elog "  cpio    - app-arch/cpio"
	elog "  deb     - app-arch/dpkg"
	elog "  iso     - app-cdr/cdrtools"
	elog "  jar,zip - app-arch/zip and app-arch/unzip"
	elog "  lha     - app-arch/lha"
	elog "  lzma    - app-arch/xz-utils"
	elog "  lzop    - app-arch/lzop"
	elog "  rar     - app-arch/unrar"
	elog "  rpm     - app-arch/rpm"
	elog "  unstuff - app-arch/stuffit"
	elog "  zoo     - app-arch/zoo"
}
