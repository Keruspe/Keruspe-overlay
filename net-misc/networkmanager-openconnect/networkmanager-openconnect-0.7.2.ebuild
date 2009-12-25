# Copyright 1999-2009 Gentoo Foundation
# Copyright 2009 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils versionator

# NetworkManager likes itself with capital letters
MY_P=${P/networkmanager/NetworkManager}
MYPV_MINOR=$(get_version_component_range 1-2)

DESCRIPTION="NetworkManager openconnect plugin."
HOMEPAGE="http://www.gnome.org/projects/NetworkManager/"
SRC_URI="mirror://gnome/sources/NetworkManager-openconnect/0.7/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~ppc ~x86"
IUSE="gnome"

RDEPEND="
	=net-misc/networkmanager-${MYPV_MINOR}*
	net-dialup/pptpclient
	gnome? (
		>=gnome-base/gconf-2.20
		>=gnome-base/gnome-keyring-2.20
		>=gnome-base/libglade-2
		>=gnome-base/libgnomeui-2.20
		>=x11-libs/gtk+-2.10
	)"

DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_configure() {
	ECONF="--disable-more-warnings \
		$(use_with gnome)"

	econf ${ECONF}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog || die "dodoc failed"
}
