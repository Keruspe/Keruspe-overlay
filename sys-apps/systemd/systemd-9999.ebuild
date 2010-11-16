# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
WANT_AUTOMAKE=1.11
inherit autotools git

EGIT_BRANCH="master"
EGIT_REPO_URI="git://anongit.freedesktop.org/systemd"

DESCRIPTION="Systemd : rethinking PID 1"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/systemd"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk pam +tcpwrap"

RDEPEND="
      >=sys-apps/dbus-1.3.2
      dev-libs/dbus-glib
	  >=sys-fs/udev-160
	  >=sys-kernel/linux-headers-2.6.32
	  sys-libs/libcap
      gtk? ( >=x11-libs/gtk+-2.20 ) 
	  tcpwrap? ( sys-apps/tcp-wrappers )
	  pam? ( virtual/pam )
	  dev-lang/vala:0.12
	  >=app-admin/syslog-ng-3"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
	app-text/build-docbook-catalog
	dev-libs/libxslt"

CFLAGS+=" -g -O0"

src_prepare() {
	eautoreconf
}

src_configure() {
	VALAC="$(type -p valac-0.12)" \
	econf --with-distro=gentoo \
		$(use_enable gtk) \
		--prefix=/usr \
		--with-rootdir=/ \
		$(use_enable pam) \
		$(use_enable tcpwrap)
}

src_install() {
	emake DESTDIR=${D} install
	dodoc "${D}/usr/share/doc/systemd"/* && \
	rm -r "${D}/usr/share/doc/systemd/"
	cd ${D}/usr/share/man/man8/
	for i in halt poweroff reboot runlevel shutdown telinit; do
		mv ${i}.8 systemd.${i}.8
	done
}
