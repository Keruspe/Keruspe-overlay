# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit git

EGIT_BRANCH="master"
EGIT_REPO_URI="git://anongit.freedesktop.org/systemd"

DESCRIPTION="Systemd"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/systemd"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-libs/libcgroup"

src_prepare() {
	sed -i '/ExecStart/s/.*/ExecStart=\/sbin\/agetty 38400 %I linux/' units/getty@.service.m4
}

src_configure() {
	./bootstrap.sh --with-distro=gentoo --prefix=/usr
}

src_install() {
	emake DESTDIR=${D} install
}
