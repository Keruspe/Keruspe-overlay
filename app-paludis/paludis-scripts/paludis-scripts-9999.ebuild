# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit git

EGIT_BRANCH="master"
EGIT_REPO_URI="git://git.pioto.org/paludis-scripts.git"

DESCRIPTION="Scripts for paludis, the other package mangler"
HOMEPAGE="http://paludis.pioto.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/paludis[ruby-bindings]"

src_unpack() {
	git_src_unpack
}

src_install() {
	cd ${S}
	insinto /usr/share/paludis/hooks/demos
	doins *.hook
	exeinto /opt/bin
	doexe `find . -maxdepth 1 -type f ! -name *.hook`
}
