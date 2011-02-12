# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit autotools git gnome2

DESCRIPTION="Collection of GSettings schemas for GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

SRC_URI=""
EGIT_REPO_URI="git://git.gnome.org/gsettings-desktop-schemas"

RDEPEND=">=dev-libs/glib-2.21:2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.40"

DOCS="AUTHORS HACKING NEWS README"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	gnome2_src_prepare
	eautoreconf
	intltoolize --force --automake
}

