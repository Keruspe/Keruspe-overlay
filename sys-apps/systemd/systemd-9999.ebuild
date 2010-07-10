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

RDEPEND="
      >=dev-libs/libcgroup-0.36
      >=sys-apps/dbus-1.3.2
      dev-libs/dbus-glib
	  >=sys-fs/udev-151
	  >=sys-kernel/linux-headers-2.6.32
	  sys-libs/libcap
      gtk? ( >=x11-libs/gtk+-2.20 ) 
	  >=dev-lang/vala-0.8
	  >=app-admin/syslog-ng-3"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
	app-text/build-docbook-catalog
	dev-libs/libxslt"

CFLAGS+=" -g -O0"
WANT_AUTOMAKE=1.11

src_prepare() {
	eautoreconf
}

src_configure() {
	econf --with-distro=gentoo \
		$(use_enable gtk) \
		--prefix=/usr \
		--with-rootdir=/
}

src_install() {
	# make sure all directory are created
	mkdir -p ${D}/cgroup/{cpu,cpuacct,cpuset,debug,devices,freezer,memory,ns,systemd}
	emake DESTDIR=${D} install
	cd ${D}/usr/share/man/man8/
	for i in halt poweroff reboot runlevel shutdown telinit; do
		mv ${i}.8 systemd.${i}.8
	done
}
