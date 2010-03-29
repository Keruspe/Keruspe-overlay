# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit games games-ggz eutils gnome2 python virtualx autotools

DESCRIPTION="Collection of games for the GNOME desktop"
HOMEPAGE="http://live.gnome.org/GnomeGames/"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="artworkextra clutter guile introspection opengl sdl test"

RDEPEND="
	>=dev-games/libggz-0.0.14
	>=dev-games/ggz-client-libs-0.0.14
	>=dev-libs/dbus-glib-0.75
	>=dev-libs/glib-2.6.3
	>=dev-libs/libxml2-2.4.0
	>=dev-python/gconf-python-2.17.3
	>=dev-python/pygobject-2
	>=dev-python/pygtk-2.14
	>=dev-python/pycairo-1
	>=gnome-base/gconf-2
	>=gnome-base/librsvg-2.14
	>=x11-libs/cairo-1
	>=x11-libs/gtk+-2.16
	x11-libs/libSM

	!sdl? ( media-libs/libcanberra[gtk] )
	sdl? (
		media-libs/libsdl
		media-libs/sdl-mixer[vorbis] )
	guile? ( >=dev-scheme/guile-1.6.5[deprecated,regex] )
	artworkextra? ( gnome-extra/gnome-games-extra-data )
	opengl? (
		dev-python/pygtkglext
		>=dev-python/pyopengl-3 )
	!games-board/glchess"

DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.53
	>=dev-util/pkgconfig-0.15
	>=dev-util/intltool-0.40.4
	>=sys-devel/gettext-0.10.40
	>=gnome-base/gnome-common-2.12.0
	>=app-text/scrollkeeper-0.3.8
	>=app-text/gnome-doc-utils-0.10
	clutter? ( media-libs/clutter-gtk
		media-libs/clutter )
	introspection? (
		dev-libs/gobject-introspection )
	test? ( >=dev-libs/check-0.9.4 )"

DOCS="AUTHORS HACKING MAINTAINERS TODO"

_omitgame() {
	G2CONF="${G2CONF},${1}"
}

pkg_setup() {
	games_pkg_setup
	G2CONF="${G2CONF}
		$(use_enable clutter staging)
		$(use_enable introspection)
		--enable-sound
		--disable-card-themes-installer
		--with-scores-group=${GAMES_GROUP}
		--with-platform=gnome
		--with-card-theme-formats=all
		--with-smclient
		--enable-omitgames=none"
		#$(use_enable clutter aisleriot-clutter)

	if ! use clutter; then
		_omitgame quadrapassel
		_omitgame lightsoff
		_omitgame swell-foop
		_omitgame gnibbles
	fi

	if ! use guile; then
		ewarn "USE='-guile' implies that Aisleriot won't be installed"
		_omitgame aisleriot
	fi

	if ! use opengl; then
		ewarn "USE=-opengl implies that glchess won't be installed"
		_omitgame glchess
	fi
}

src_prepare() {
	gnome2_src_prepare
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

src_test() {
	Xemake check || die "tests failed"
}

src_install() {
	gnome2_src_install
	for game in \
	$(find . -maxdepth 1 -type d ! -name po ! -name libgames-support); do
		docinto ${game}
		for doc in AUTHORS ChangeLog NEWS README TODO; do
			[ -s ${game}/${doc} ] && dodoc ${game}/${doc}
		done
	done
}

pkg_preinst() {
	gnome2_pkg_preinst
	local basefile
	for scorefile in "${D}"/var/lib/games/*.scores; do
		basefile=$(basename $scorefile)
		if [ -s "${ROOT}/var/lib/games/${basefile}" ]; then
			cp "${ROOT}/var/lib/games/${basefile}" \
			"${D}/var/lib/games/${basefile}"
		fi
	done
}

pkg_postinst() {
	games_pkg_postinst
	games-ggz_update_modules
	gnome2_pkg_postinst
	python_need_rebuild
}

pkg_postrm() {
	games-ggz_update_modules
	gnome2_pkg_postrm
}
