# Copyright 2009 Marc-Antoine Perennou
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="paludis-1"

SCM_REPOSITORY="git://git.pioto.org/paludis-scripts.git"
SCM_CHECKOUT_TO="${DISTDIR}/git-src/paludis-scripts"
inherit scm-git

DESCRIPTION="Scripts for paludis, the other package mangler"
HOMEPAGE="http://paludis.pioto.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/paludis[ruby-bindings]"

src_unpack() {
	scm_src_unpack
}

src_install() {
	cd ${S}
	insinto /usr/share/paludis/hooks/demos
	doins *.hook
	exeinto /opt/sbin
	doexe `find . -maxdepth 1 -type f ! -name *.hook`
}
