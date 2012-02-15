# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
WANT_AUTOMAKE=1.11

inherit autotools bash-completion-r1 git-2 linux-info pam systemd

DESCRIPTION="System and service manager for Linux"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/systemd"
EGIT_REPO_URI="git://anongit.freedesktop.org/systemd/systemd"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="acl audit cryptsetup gtk lzma +pam python plymouth selinux symlinks +tcpd"

COMMON_DEPEND=">=sys-apps/dbus-1.4.10
	>=sys-apps/util-linux-2.19
	>=sys-fs/udev-172
	sys-libs/libcap
	acl? ( sys-apps/acl )
	audit? ( >=sys-process/audit-2 )
	cryptsetup? ( sys-fs/cryptsetup )
	gtk? (
		dev-libs/dbus-glib
		>=dev-libs/glib-2.26
		dev-libs/libgee:0
		x11-libs/gtk+:2
		>=x11-libs/libnotify-0.7 )
	lzma? ( app-arch/xz-utils )
	pam? ( virtual/pam )
	python? ( dev-python/dbus-python
	  dev-python/pycairo )
	symlinks? ( !!sys-apps/sysvinit )
	plymouth? ( sys-boot/plymouth )
	selinux? ( sys-libs/libselinux )
	tcpd? ( sys-apps/tcp-wrappers )"

# Vala-0.10 doesn't work with libnotify 0.7.1
VALASLOT="0.14"
# A little higher than upstream requires
# but I had real trouble with 2.6.37 and systemd.
MINKV="2.6.38"

# dbus, udev versions because of systemd units
# blocker on old packages to avoid collisions with above
# openrc blocker to avoid udev rules starting openrc scripts
RDEPEND="${COMMON_DEPEND}
	app-admin/syslog-ng
	sys-apps/baselayout-systemd
	sys-apps/lsb-release
	sys-apps/systemd-units
	sys-auth/nss-myhostname
	!<sys-apps/openrc-0.8.3"
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	dev-util/gperf
	dev-util/intltool
	dev-lang/vala:${VALASLOT}
	>=sys-kernel/linux-headers-${MINKV}"

pkg_setup() {
	enewgroup lock # used by var-lock.mount
	enewgroup tty 5 # used by mount-setup for /dev/pts
}

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	intltoolize --force --copy --automake
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-distro=gentoo
		# install everything to /usr
		--with-rootprefix=/usr
		--with-rootlibdir=/usr/$(get_libdir)
		# but pam modules have to lie in /lib*
		--with-pamlibdir=/$(get_libdir)/security
		--localstatedir=/var
		$(use_enable acl)
		$(use_enable audit)
		$(use_enable cryptsetup libcryptsetup)
		$(use_enable gtk)
		$(use_enable lzma xz)
		$(use_enable pam)
		$(use_enable plymouth)
		$(use_enable selinux)
		$(use_enable tcpd tcpwrap)
	)

	if use gtk; then
		export VALAC="$(type -p valac-${VALASLOT})"
	fi

	econf ${myeconfargs}
}

rename_mans() {
	cd ${ED}/usr/share/man/man8/
	for i in halt poweroff reboot runlevel shutdown telinit; do
		mv ${i}.8 systemd.${i}.8
	done
}

do_symlinks() {
	dosym /usr/$(get_libdir)/systemd/systemd /sbin/init
	for i in poweroff halt reboot shutdown; do
		dosym /usr/bin/systemctl /sbin/${i}
	done
}

src_install() {
	emake DESTDIR="${ED}" install
	# move files as necessary
	newbashcomp "${S}"/src/systemd-bash-completion.sh systemd
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

pkg_preinst() {
	local CONFIG_CHECK="~AUTOFS4_FS ~CGROUPS ~DEVTMPFS ~FANOTIFY ~IPV6"
	kernel_is -ge ${MINKV//./ } || ewarn "Kernel version at least ${MINKV} required"
	check_extra_config
}

optfeature() {
	elog "	[\e[1m$(has_version ${1} && echo I || echo ' ')\e[0m] ${1} (${2})"
}

pkg_postinst() {
	mkdir -p "${ROOT}"/run || ewarn "Unable to mkdir /run, this could mean trouble."
	if [[ ! -L "${ROOT}"/etc/mtab ]]; then
		ewarn "Upstream suggests that the /etc/mtab file should be a symlink to /proc/mounts."
		ewarn "It is known to cause users being unable to unmount user mounts. If you don't"
		ewarn "require that specific feature, please call:"
		ewarn "	$ ln -sf '${ROOT}proc/self/mounts' '${ROOT}etc/mtab'"
		ewarn
	fi

	elog "You may need to perform some additional configuration for some programs"
	elog "to work, see the systemd manpages for loading modules and handling tmpfiles:"
	elog "	$ man modules-load.d"
	elog "	$ man tmpfiles.d"
	elog

	elog "To get additional features, a number of optional runtime dependencies may"
	elog "be installed:"
	optfeature 'dev-python/dbus-python' 'for systemd-analyze'
	optfeature 'dev-python/pycairo[svg]' 'for systemd-analyze plotting ability'
	elog

	ewarn "Please note this is a work-in-progress and many packages in Gentoo"
	ewarn "do not supply systemd unit files yet. You are testing it on your own"
	ewarn "responsibility. Please remember than you can pass:"
	ewarn "	init=/sbin/init"
	ewarn "to your kernel to boot using sysvinit / OpenRC."
}
