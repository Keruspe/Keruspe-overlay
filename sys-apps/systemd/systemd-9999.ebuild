# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools git

EGIT_BRANCH="master"
EGIT_REPO_URI="git://anongit.freedesktop.org/systemd"

DESCRIPTION="Systemd : rethinking PID 1"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/systemd"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

RDEPEND=">=dev-lang/vala-0.8
      >=dev-libs/libcgroup-0.36
      >=sys-apps/dbus-1.2.24
      >=sys-fs/udev-151
	  >=sys-kernel/linux-headers-2.6.32
	  sys-libs/libcap
      gtk? ( >=x11-libs/gtk+-2.20 )"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd
	app-text/docbook-xsl-stylesheets
	app-text/build-docbook-catalog
	dev-libs/libxslt"

CFLAGS+=" -g -O0"
WANT_AUTOMAKE=2.11

src_prepare() {
	eautoreconf
}

src_configure() {
	econf --with-distro=gentoo \
		$(use_enable gtk) \
		--libexecdir=/usr/libexec \
		--prefix=/
}

src_install() {
	emake DESTDIR=${D} install
}
