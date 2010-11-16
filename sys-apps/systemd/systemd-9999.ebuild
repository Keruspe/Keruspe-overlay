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
IUSE="audit cryptsetup gtk pam selinux +tcpwrap"

RDEPEND="
      audit? ( sys-process/audit )
	  cryptsetup? ( sys-fs/cryptsetup )
      gtk? ( >=x11-libs/gtk+-2.20:2
      	dev-libs/dbus-glib
		>=x11-libs/libnotify-0.7 )
	  pam? ( virtual/pam )
	  tcpwrap? ( sys-apps/tcp-wrappers )
	  >=sys-apps/dbus-1.3.2
	  >=sys-fs/udev-160
	  >=sys-kernel/linux-headers-2.6.32
	  sys-libs/libcap
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
		--prefix=/usr \
		--with-rootdir=/ \
		$(use_enable audit) \
		$(use_enable cryptsetup libcryptsetup) \
		$(use_enable gtk) \
		$(use_enable pam) \
		$(use_enable selinux) \
		$(use_enable tcpwrap)
}

src_install() {
	emake DESTDIR=${ED} install
	dodoc "${ED}/usr/share/doc/systemd"/* && \
	rm -r "${ED}/usr/share/doc/systemd/"
	cd ${ED}/usr/share/man/man1/
	mv init.1 systemd.init.1
	cd ${ED}/usr/share/man/man5/
	mv tmpfiles.d.5 systemd.tmpfiles.d.5
	cd ${ED}/usr/share/man/man7/
	mv daemon.7 systemd.daemon.7
	cd ${ED}/usr/share/man/man8/
	for i in telinit shutdown runlevel reboot poweroff halt; do
		mv ${i}.8 systemd.${i}.8
	done
}
