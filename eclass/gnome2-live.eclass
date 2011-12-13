# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# @ECLASS: gnome2-live.eclass
# @MAINTAINER:
# gnome@gentoo.org
# @AUTHOR:
# Nirbheek Chauhan <nirbheek@gentoo.org>
# @BLURB: Live ebuild phases for GNOME packages
# @DESCRIPTION:
# Exports additional functions used by live ebuilds written for GNOME packages
# Always to be imported *AFTER* gnome2.eclass
#

inherit autotools gnome2 gnome2-utils libtool git-2

# Stolen from git.eclass
EXPORTED_FUNCTIONS="src_unpack pkg_postinst"
case "${EAPI:-0}" in
    2|3|4) EXPORTED_FUNCTIONS="${EXPORTED_FUNCTIONS} src_prepare" ;;
    0|1) ;;
    *) die "Unknown EAPI, Bug eclass maintainers." ;;
esac
EXPORT_FUNCTIONS ${EXPORTED_FUNCTIONS}

# DEPEND on
# app-text/gnome-doc-utils for gnome-doc-*
# dev-util/gtk-doc for gtkdocize
# dev-util/intltool for intltoolize
# gnome-base/gnome-common for GNOME_COMMON_INIT
DEPEND="${DEPEND}
	app-text/gnome-doc-utils
	dev-util/gtk-doc
	dev-util/intltool
	gnome-base/gnome-common
	sys-devel/gettext"

# Extra options passed to elibtoolize
ELTCONF=${ELTCONF:-}

# @ECLASS-VARIABLE: GNOME_LIVE_MODULE
# @DESCRIPTION:
# Default git module name is assumed to be the same as the gnome.org module name
# used on ftp.gnome.org. We have GNOME_ORG_MODULE because we inherit gnome.org
: ${GNOME_LIVE_MODULE:="${GNOME_ORG_MODULE}"}

# @ECLASS-VARIABLE: EGIT_REPO_URI
# @DESCRIPTION:
# git URI for the project, uses GNOME_LIVE_MODULE by default
: "${EGIT_REPO_URI:="git://git.gnome.org/${GNOME_LIVE_MODULE}"}"

# @ECLASS-VARIABLE: PATCHES
# @DESCRIPTION:
# Whitespace-separated list of patches to apply after cloning
: ${PATCHES:=""}

# Unset SRC_URI auto-set by gnome2.eclass
SRC_URI=""

# @FUNCTION: gnome2-live_get_var
# @DESCRIPTION:
# Get macro variable values from configure.ac, etc
gnome2-live_get_var() {
	local var f
	var="$1"
	f="$2"
	echo $(sed -ne "s/${var}(\(.*\))/\1/p" "${f}" | tr -d '[]')
}

# @FUNCTION: gnome2-live_get_var
# @DESCRIPTION:
# Calls git-2_src_unpack, and unpacks ${A} if required.
# Also calls gnome2-live_src_prepare for older EAPI.
gnome2-live_src_unpack() {
	if test -n "${A}"; then
		unpack ${A}
	fi
	git-2_src_unpack
	has src_prepare ${EXPORTED_FUNCTIONS} || gnome2-live_src_prepare
}

# @FUNCTION: gnome2-live_src_prepare
# @DESCRIPTION:
# Lots of magic to workaround autogen.sh quirks in various packages
# Creates blank ChangeLog and necessary macro dirs. Runs various autotools
# programs if required, and finally runs eautoreconf.
gnome2-live_src_prepare() {
	# Blame git.eclass
	cd "${S}"

	for i in ${PATCHES}; do
		epatch "${i}"
	done

	# If ChangeLog doesn't exist, maybe it's autogenerated
	# Avoid a `dodoc` failure by adding an empty ChangeLog
	if ! test -e ChangeLog; then
		echo > ChangeLog
	fi

	# Find and create macro dirs
	local macro_dirs=($(gnome2-live_get_var AC_CONFIG_MACRO_DIR configure.*))
	for i in "${macro_dirs[@]}"; do
		mkdir -p "$i"
	done

	# We don't run gettextize because that does too much stuff
	if grep -qe 'GETTEXT' configure.*; then
		# Generate po/Makefile.in.in if it doesn't exist for packages that use
		# AM_GNU_GETTEXT and AM_GNU_GETTEXT_VERSION (e.g. media-libs/cogl).
		# Logic is inspired by gnome-autogen.sh
		if ! grep -qe '^AM_GLIB_GNU_GETTEXT' configure.* &&
		   grep -qe '^AM_GNU_GETTEXT_VERSION' configure.* &&
		   [[ -d po && ! -e po/Makefile.in.in && ! -e po/Makefile.am ]]; then
			eautopoint --force
		fi
		local aux_dir=${S}/$(gnome2-live_get_var AC_CONFIG_AUX_DIR configure.*)
		mkdir -p "${aux_dir}"
		test -e "${aux_dir}/config.rpath" || :> "${aux_dir}/config.rpath"
		test -e "${aux_dir}/ABOUT-NLS" || cp "${ROOT}/usr/share/gettext/ABOUT-NLS" "${aux_dir}"
	fi

	if grep -qe 'GTK_DOC' configure.*; then
		ebegin "Running gtkdocize"
		gtkdocize
		eend $?
	fi
	if grep -qe 'GNOME_DOC_INIT' configure.*; then
		ebegin "Running gnome-doc-common"
		gnome-doc-common
		eend $?
		ebegin "Running gnome-doc-prepare --automake"
		gnome-doc-prepare --automake
		eend $?
	fi
	if grep -qe "IT_PROG_INTLTOOL" -e "AC_PROG_INTLTOOL" configure.*; then
		if grep -qe "AC_PROG_INTLTOOL" configure.*; then
			eqawarn "This package is using deprecated AC_PROG_INTLTOOL macro."
			eqawarn "Please fill a bug to the upstream of this package."
		fi
		ebegin "Running intltoolize --force --automake"
		intltoolize --force --automake
		eend $?
	fi
	if test -e m4; then
		AT_M4DIR=m4 eautoreconf
	else
		eautoreconf
	fi

	# Disable pyc compiling. Doesn't harm if DNE
	ln -sf $(type -P true) py-compile

	### Keep this in-sync with gnome2.eclass!

	# Don't use the session bus address inherited via the environment
	# causes test and introspection-building failures
	unset DBUS_SESSION_BUS_ADDRESS

	# Prevent scrollkeeper access violations
	gnome2_omf_fix

	# Libtool patching
	elibtoolize ${ELTCONF}
}

# @FUNCTION: gnome2_src_unpack
# @DESCRIPTION:
# Defined so that it replaces gnome2_src_unpack in ebuilds that call it
gnome2_src_unpack() {
	gnome2-live_src_unpack
}

# @FUNCTION: gnome2_src_prepare
# @DESCRIPTION:
# Defined so that it replaces gnome2_src_prepare in ebuilds that call it
gnome2_src_prepare() {
	gnome2-live_src_prepare
}

# @FUNCTION: gnome2-live_pkg_postinst
# @DESCRIPTION:
# Must be run manually for ebuilds that have a custom pkg_postinst
gnome2-live_pkg_postinst() {
	gnome2_pkg_postinst
	ewarn "This is a live ebuild, upstream scms will mostly be UNstable"
	ewarn "Do NOT report bugs about this package to Gentoo"
	ewarn "Report upstream bugs (with patches if possible) instead."
}
