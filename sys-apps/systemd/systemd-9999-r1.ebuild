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
KEYWORDS=""
IUSE="audit cryptsetup gtk +pam python plymouth selinux symlinks +tcpwrap"

COMMON_DEPEND=">=sys-apps/dbus-1.4.8-r1
	sys-libs/libcap
	>=sys-fs/udev-168
	audit? ( sys-process/audit )
	cryptsetup? ( sys-fs/cryptsetup )
	gtk? (
		dev-libs/dbus-glib
		>=dev-libs/glib-2.26
		x11-libs/gtk+:2
		>=x11-libs/libnotify-0.7 )
	pam? ( virtual/pam )
	python? ( dev-python/dbus-python
	  dev-python/pycairo )
	symlinks? ( !!sys-apps/sysvinit )
	selinux? ( sys-libs/libselinux )
	tcpwrap? ( sys-apps/tcp-wrappers )
	>=sys-apps/util-linux-2.19
	plymouth? ( >=sys-boot/plymouth-0.8.4 )"

RDEPEND="${COMMON_DEPEND}
	sys-apps/systemd-units
	>=app-admin/syslog-ng-3
	sys-apps/lsb-release
	sys-apps/baselayout-systemd"
VALASLOT="0.12"
MINKV="2.6.38"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	gtk? ( dev-lang/vala:${VALASLOT} )
	>=sys-kernel/linux-headers-${MINKV}"

check_no_uevent_hotplug_helper() {
	local path
	if linux_config_exists; then
		path="$(linux_chkconfig_string UEVENT_HELPER_PATH)"
		path="${path#\"}"
		path="${path%\"}"
		path="${path#\'}"
		path="${path%\'}"
		if test "${path}" != ""; then
			qewarn "The kernel should be configured with"
			qewarn "CONFIG_UEVENT_HELPER_PATH=\"\". Also, be sure to check"
			qewarn "that /proc/sys/kernel/hotplug is empty."
		fi
	fi
}

pkg_pretend() {
	local CONFIG_CHECK="AUTOFS4_FS CGROUPS DEVTMPFS ~FANOTIFY ~IPV6"
	linux-info_pkg_setup
	check_no_uevent_hotplug_helper
	kernel_is -ge ${MINKV//./ } || die "Kernel version at least ${MINKV} required"
}

pkg_setup() {
	enewgroup lock # used by var-lock.mount
	enewgroup tty 5 # used by mount-setup for /dev/pts
}

src_prepare() {
	epatch_user
	intltoolize --force --copy --automake
	eautoreconf
}

src_configure() {
	local myconf="
		--with-distro=gentoo
		--with-rootdir=
		--localstatedir=/var
		$(use_enable audit)
		$(use_enable cryptsetup libcryptsetup)
		$(use_enable gtk)
		$(use_enable pam)
		$(use_enable selinux)
		$(use_enable tcpwrap)
	"

	use gtk && export VALAC="$(type -p valac-${VALASLOT})"

	use plymouth && export have_plymouth=1

	econf ${myconf}
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
	emake DESTDIR=${ED} install

	dodoc "${ED}"/usr/share/doc/systemd/*
	rm -rf "${ED}"/usr/share/doc/systemd

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
		elog
	fi
}

systemd_machine_id_setup() {
	einfo "Setting up /etc/machine-id..."
	if ! "${ROOT}"bin/systemd-machine-id-setup; then
		ewarn "Setting up /etc/machine-id failed, to fix it please see"
		ewarn "  http://lists.freedesktop.org/archives/dbus/2011-March/014187.html"
		elog
	elif test ! -L "${ROOT}"var/lib/dbus/machine-id; then
		# This should be fixed in the dbus ebuild, but we warn about it here.
		ewarn "${ROOT}var/lib/dbus/machine-id ideally should be a symlink to"
		ewarn "${ROOT}etc/machine-id to make it clear that they have the same"
		ewarn "content."
		elog
	else
		einfo
	fi
}

check_var_run_is_symlink() {
	if test ! -L "${ROOT}"var/run; then
		elog "${ROOT}var/run should be a symlink to ${ROOT}run. This is not"
		elog "trivial to change, and there is no hurry as it is currently"
		elog "bind-mounted at boot-time. You may be able to create the"
		elog "symlink by lazily unmounting ${ROOT}var/run first."
		elog
	fi
}

check_var_lock_is_symlink() {
	if test ! -L "${ROOT}"var/lock; then
		elog "${ROOT}var/lock should be a symlink to ${ROOT}run/lock, see"
		elog "  https://lwn.net/Articles/436012/"
		elog
	fi
}

pkg_postinst() {
	check_mtab_is_symlink
	systemd_machine_id_setup
	check_var_run_is_symlink
	check_var_lock_is_symlink

	# Inform user about extra configuration
	elog "You may need to perform some additional configuration for some"
	elog "programs to work, see the systemd manpages for loading modules and"
	elog "handling tmpfiles:"
	elog "    $ man modules-load.d"
	elog "    $ man tmpfiles.d"
	elog

	ewarn "This is a work-in-progress ebuild. You may brick your system. Have fun!"
}
