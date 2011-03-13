# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils git toolchain-funcs linux-info

DESCRIPTION="Manage special features such as screen and keyboard backlight on Apple MacBook Pro/PowerBook"
HOMEPAGE="http://technologeek.org/projects/pommed/index.html"
SRC_URI=""
EGIT_REPO_URI="git://git.debian.org/pommed/pommed.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk X"

COMMON_DEPEND="media-libs/alsa-lib
	sys-apps/pciutils
	dev-libs/confuse
	>=sys-apps/dbus-1.1
	dev-libs/dbus-glib
	sys-libs/zlib
	media-libs/audiofile
	gtk? ( >=x11-libs/gtk+-2 )
	X? ( x11-libs/libX11
		x11-libs/libXpm )"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	media-sound/alsa-utils
	virtual/eject"

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK="~DMIID"
	check_extra_config
}

src_unpack() {
	git_src_unpack
}

src_prepare() {
	epatch ${FILESDIR}/fix-backlight.patch
}

src_compile() {
	emake CC="$(tc-getCC)" OFLIB=1 || die "emake pommed failed"

	if use gtk; then
		cd "${S}"/gpomme
		local POFILES=""
		for LANG in ${LINGUAS}; do
			if [ -f po/${LANG}.po ]; then
				POFILES="${POFILES} po/${LANG}.po"
			fi
		done
		emake CC="$(tc-getCC)" POFILES="${POFILES}" || die "emake gpomme failed"
	fi
	if use X; then
		cd "${S}"/wmpomme
		emake CC="$(tc-getCC)" || die "emake wmpomme failed"
	fi
}

src_install() {
	insinto /etc
	newins pommed.conf.mactel pommed.conf

	insinto /etc/dbus-1/system.d
	newins dbus-policy.conf pommed.conf

	insinto /usr/share/pommed
	doins pommed/data/*.wav

	dobin pommed/pommed

	newinitd "${FILESDIR}"/pommed.rc pommed

	dodoc AUTHORS ChangeLog README TODO

	if use gtk ; then
		dobin gpomme/gpomme
		for LANG in ${LINGUAS}; do
			if [ -f gpomme/po/${LANG}.mo ]; then
				einfo "Installing lang ${LANG}"
				insinto /usr/share/locale/${LANG}/LC_MESSAGES/
				doins gpomme/po/${LANG}.mo
			fi
		done

		insinto /usr/share/applications
		doins gpomme/gpomme.desktop
		doins gpomme/gpomme-c.desktop
		insinto /usr/share/gpomme/
		doins -r gpomme/themes
	fi

	if use X ; then
		dobin wmpomme/wmpomme
	fi
}
