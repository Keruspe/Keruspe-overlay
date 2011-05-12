# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
WANT_AUTOMAKE=1.11
inherit autotools git-2 linux-info pam

DESCRIPTION="systemd is a system and service manager for Linux"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/systemd"
EGIT_REPO_URI="git://anongit.freedesktop.org/systemd"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="audit cryptsetup gtk +pam python selinux symlinks sysv +tcpwrap"

RDEPEND="
	>=sys-apps/dbus-1.4.0
	sys-libs/libcap
	>=sys-fs/udev-168
	audit? ( sys-process/audit )
	cryptsetup? ( sys-fs/cryptsetup )
	gtk? (  >=x11-libs/gtk+-2.20:2
		    x11-libs/libnotify
			dev-libs/dbus-glib )
	tcpwrap? ( sys-apps/tcp-wrappers )
	pam? ( virtual/pam )
	python? ( dev-python/dbus-python
	  dev-python/pycairo )
	symlinks? ( !!sys-apps/sysvinit )
	selinux? ( sys-libs/libselinux )
	>=sys-apps/util-linux-2.19
	sys-apps/systemd-units
	>=app-admin/syslog-ng-3
	sys-apps/lsb-release
	sys-apps/baselayout-systemd"
DEPEND="${RDEPEND}
	gtk? ( dev-lang/vala:0.12 )
	>=sys-kernel/linux-headers-2.6.32"

CONFIG_CHECK="AUTOFS4_FS CGROUPS DEVTMPFS ~FANOTIFY ~IPV6"

pkg_setup() {
	enewgroup lock # used by var-lock.mount
	enewgroup tty 5 # used by mount-setup for /dev/pts
}

pkg_pretend() {
	check_extra_config
}

src_prepare() {
	eautoreconf
}

src_configure() {
	local myconf=

	if use sysv; then
		myconf="${myconf} --with-sysvinit-path=/etc/init.d --with-sysvrcd-path=/etc"
	else
		myconf="${myconf} --with-sysvinit-path= --with-sysvrcd-path="
	fi

	if use gtk; then
		export VALAC="$(type -p valac-0.12)"
	fi

	econf --with-distro=gentoo \
		--with-rootdir= \
		--localstatedir=/var \
		$(use_enable audit) \
		$(use_enable cryptsetup libcryptsetup) \
		$(use_enable gtk) \
		$(use_enable pam) \
		$(use_enable tcpwrap) \
		$(use_enable selinux) \
		${myconf}
}

rename_mans() {
	cd ${ED}/usr/share/man/man8/
	for i in telinit shutdown runlevel reboot poweroff halt; do
		mv ${i}.8 systemd.${i}.8
	done
}

do_symlinks() {
    dosym /bin/systemctl /sbin/init
    dosym /bin/systemctl /sbin/poweroff
    dosym /bin/systemctl /sbin/halt
    dosym /bin/systemctl /sbin/reboot
    dosym /bin/systemctl /sbin/shutdown
}

src_install() {
	emake DESTDIR=${ED} install || die "emake install failed"

	dodoc "${ED}/usr/share/doc/systemd"/* && \
		rm -r "${ED}/usr/share/doc/systemd/"

	keepdir /run
	if use symlinks; then
	    do_symlinks
	else
		rename_mans
	fi
	find ${ED} -name '*.la' -exec rm -f {} +
}

check_mtab_is_symlink() {
	if test ! -L "${ROOT}"etc/mtab; then
		ewarn "${ROOT}etc/mtab must be a symlink to ${ROOT}proc/self/mounts!"
		ewarn "To correct that, execute"
		ewarn "    $ ln -sf '${ROOT}proc/self/mounts' '${ROOT}etc/mtab'"
	fi
}

systemd_machine_id_setup() {
	einfo "Setting up /etc/machine-id..."
	"${ROOT}"bin/systemd-machine-id-setup
	if test $? != 0; then
		ewarn "Setting up /etc/machine-id failed, to fix it please see"
		ewarn "  http://lists.freedesktop.org/archives/dbus/2011-March/014187.html"
	elif test ! -L "${ROOT}"var/lib/dbus/machine-id; then
		# This should be fixed in the dbus ebuild, but we warn about it here.
		ewarn "${ROOT}var/lib/dbus/machine-id ideally should be a symlink to"
		ewarn "${ROOT}etc/machine-id to make it clear that they have the same"
		ewarn "content."
	fi
}

pkg_postinst() {
	check_mtab_is_symlink

	systemd_machine_id_setup

	# Inform user about extra configuration
	elog "You may need to perform some additional configuration for some"
	elog "programs to work, see the systemd manpages for loading modules and"
	elog "handling tmpfiles:"
	elog "    $ man modules-load.d"
	elog "    $ man tmpfiles.d"
}
