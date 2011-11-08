# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2-live multilib pam virtualx

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE="+caps debug doc pam test"
KEYWORDS=""

# USE=valgrind is probably not a good idea for the tree
RDEPEND=">=dev-libs/glib-2.25:2
	gnome-base/gcr
	>=x11-libs/gtk+-2.90.0:3
	>=app-crypt/p11-kit-0.6
	app-misc/ca-certificates
	>=dev-libs/libgcrypt-1.2.2
	>=dev-libs/libtasn1-1
	>=sys-apps/dbus-1.0
	caps? ( sys-libs/libcap-ng )
	pam? ( virtual/pam )
"
#	valgrind? ( dev-util/valgrind )
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.9 )"
PDEPEND=">=gnome-base/libgnome-keyring-3.1.92"
# eautoreconf needs:
#	>=dev-util/gtk-doc-am-1.9

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable test tests)
		$(use_with caps libcap-ng)
		$(use_enable pam)
		$(use_with pam pam-dir $(getpam_mod_dir))
		--with-root-certs=${EPREFIX}/etc/ssl/certs/
		--enable-ssh-agent
		--enable-gpg-agent
		--disable-update-mime"
	MAKEOPTS+=" -j1"
}

src_test() {
	# FIXME: /gkm/transaction/ tests fail
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "emake check failed!"
}

pkg_postinst() {
	use caps && fcaps 0:0 755 cap_ipc_lock "${ROOT}"/usr/bin/gnome-keyring-daemon

	gnome2_pkg_postinst
}

# borrowed from GSoC2010_Gentoo_Capabilities by constanze and Flameeyes
# @FUNCTION: fcaps
# @USAGE: fcaps {uid:gid} {file-mode} {cap1[,cap2,...]} {file}
# @RETURN: 0 if all okay; non-zero if failure and fallback
# @DESCRIPTION:
# fcaps sets the specified capabilities in the effective and permitted set of
# the given file. In case of failure fcaps sets the given file-mode.
fcaps() {
	local uid_gid=$1
	local perms=$2
	local capset=$3
	local path=$4
	local res

	chmod $perms $path && \
	chown $uid_gid $path
	res=$?

	use caps || return $res

	#set the capability
	setcap "$capset=ep" "$path" &> /dev/null
	#check if the capabilitiy got set correctly
	setcap -v "$capset=ep" "$path" &> /dev/null
	res=$?

	if [ $res -ne 0 ]; then
		ewarn "Failed to set capabilities. Probable reason is missed kernel support."
		ewarn "Kernel must have SECURITY_FILE_CAPABILITIES, and <FS>_FS_SECURITY"
		ewarn "enabled (e.g. EXT3_FS_SECURITY) where <FS> is the filesystem to store"
		ewarn "${path}"
		ewarn
		ewarn "Falling back to suid now..."
		chmod u+s ${path}
	fi
	return $res
}
