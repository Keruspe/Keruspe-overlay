# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gnome2.eclass,v 1.87 2010/04/26 19:37:25 abcd Exp $

#
# gnome2.eclass
#
# Exports portage base functions used by ebuilds written for packages using the
# GNOME framework. For additional functions, see gnome2-utils.eclass.
#
# Maintained by Gentoo's GNOME herd <gnome@gentoo.org>
#


inherit fdo-mime libtool gnome.org gnome2-utils

case "${EAPI:-0}" in
	0|1)
		EXPORT_FUNCTIONS src_unpack src_compile src_install pkg_preinst pkg_postinst pkg_postrm
		;;
	2|3|4)
		EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install pkg_preinst pkg_postinst pkg_postrm
		;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

# Extra configure opts passed to econf
G2CONF=${G2CONF:-""}

# Should we delete all the .la files?
# Do NOT use without due consideration
GNOME2_LA_PUNT=${GNOME2_LA_PUNT:-"no"}

# Extra options passed to elibtoolize
ELTCONF=${ELTCONF:-""}

# Should we use EINSTALL instead of DESTDIR
USE_EINSTALL=${USE_EINSTALL:-""}

# Run scrollkeeper for this package?
SCROLLKEEPER_UPDATE=${SCROLLKEEPER_UPDATE:-"1"}



if [[ ${GCONF_DEBUG} != "no" ]]; then
	IUSE="debug"
fi



gnome2_src_unpack() {
	unpack ${A}
	cd "${S}"
	has ${EAPI:-0} 0 1 && gnome2_src_prepare
}

gnome2_src_prepare() {
	# Reset various variables inherited via the environment.
	# Causes test failures, introspection-build failures, and access violations
	unset DBUS_SESSION_BUS_ADDRESS
	unset DISPLAY
	unset GNOME_KEYRING_CONTROL
	unset GNOME_KEYRING_PID
	unset XAUTHORITY
	unset XDG_SESSION_COOKIE

	# Reset the XDG_* directories to avoid access violations
	export XDG_DATA_HOME="${T}/.local/share"
	export XDG_CONFIG_HOME="${T}/.config"
	export XDG_CACHE_HOME="${T}/.cache"
	export XDG_RUNTIME_DIR="${T}/run"
	mkdir -p "${XDG_DATA_HOME}" "${XDG_CONFIG_HOME}" "${XDG_CACHE_HOME}" \
			 "${XDG_RUNTIME_DIR}"
	# This directory needs to be owned by the user, and chmod 0700
	# http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
	chmod 0700 "${XDG_RUNTIME_DIR}"

	# Prevent scrollkeeper access violations
	gnome2_omf_fix

	# Run libtoolize
	if has ${EAPI:-0} 0 1 2 3; then
		elibtoolize ${ELTCONF}
	else
		# Everything is fatal EAPI 4 onwards
		nonfatal elibtoolize ${ELTCONF}
	fi

}

gnome2_src_configure() {
	# Update the GNOME configuration options
	if [[ ${GCONF_DEBUG} != 'no' ]] ; then
		if use debug ; then
			G2CONF="${G2CONF} --enable-debug=yes"
		fi
	fi

	# Prevent a QA warning
	if hasq doc ${IUSE} ; then
		G2CONF="${G2CONF} $(use_enable doc gtk-doc)"
	fi

	# Avoid sandbox violations caused by misbehaving packages (bug #128289)
	addwrite "/root/.gnome2"

	# GST_REGISTRY is to work around gst-inspect trying to read/write /root
	GST_REGISTRY="${S}/registry.xml" econf "$@" ${G2CONF}
}

gnome2_src_compile() {
	has ${EAPI:-0} 0 1 && gnome2_src_configure "$@"
	emake || die "compile failure"
}

gnome2_src_install() {
	has ${EAPI:-0} 0 1 2 && ! use prefix && ED="${D}"
	# if this is not present, scrollkeeper-update may segfault and
	# create bogus directories in /var/lib/
	local sk_tmp_dir="/var/lib/scrollkeeper"
	dodir "${sk_tmp_dir}" || die "dodir failed"

	# we must delay gconf schema installation due to sandbox
	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"

	if [[ -z "${USE_EINSTALL}" || "${USE_EINSTALL}" = "0" ]]; then
		debug-print "Installing with 'make install'"
		emake DESTDIR="${D}" "scrollkeeper_localstate_dir=${ED}${sk_tmp_dir} " "$@" install || die "install failed"
	else
		debug-print "Installing with 'einstall'"
		einstall "scrollkeeper_localstate_dir=${ED}${sk_tmp_dir} " "$@" || die "einstall failed"
	fi

	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL

	# Manual document installation
	if [[ -n "${DOCS}" ]]; then
		dodoc ${DOCS} || die "dodoc failed"
	fi

	# Do not keep /var/lib/scrollkeeper because:
	# 1. The scrollkeeper database is regenerated at pkg_postinst()
	# 2. ${ED}/var/lib/scrollkeeper contains only indexes for the current pkg
	#    thus it makes no sense if pkg_postinst ISN'T run for some reason.
	if [[ -z "$(find "${D}" -name '*.omf')" ]]; then
		export SCROLLKEEPER_UPDATE="0"
	fi
	rm -rf "${ED}${sk_tmp_dir}"

	# Make sure this one doesn't get in the portage db
	rm -fr "${ED}/usr/share/applications/mimeinfo.cache"

	# Delete all .la files
	if [[ "${GNOME2_LA_PUNT}" != "no" ]]; then
		ebegin "Removing .la files"
		find "${D}" -name '*.la' -exec rm -f {} + || die
		eend
	fi
}

gnome2_pkg_preinst() {
	gnome2_gconf_savelist
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

gnome2_pkg_postinst() {
	gnome2_gconf_install
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update

	if [[ "${SCROLLKEEPER_UPDATE}" = "1" ]]; then
		gnome2_scrollkeeper_update
	fi
	# This should only be in the overlay
	ewarn "**************************************************************"
	ewarn "This is the *experimental* Keruspe Overlay"
	ewarn "Please report bugs at Marc-Antoine@Perennou.com"
	ewarn "Do NOT go to upstream with bugs without checking with me first"
	ewarn "**************************************************************"
}

#gnome2_pkg_prerm() {
#	gnome2_gconf_uninstall
#}

gnome2_pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update --uninstall

	if [[ "${SCROLLKEEPER_UPDATE}" = "1" ]]; then
		gnome2_scrollkeeper_update
	fi
}

# pkg_prerm
