# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit autotools bash-completion-r1 gnome2-live

DESCRIPTION="Clipboard management system"
HOMEPAGE="http://github.com/Keruspe/GPaste"
EGIT_REPO_URI="git://github.com/Keruspe/GPaste.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="applet bash-completion +gnome-shell zsh-completion"

DEPEND=">=dev-libs/glib-2.30:2
	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.40
	>=x11-libs/gtk+-3.0.0:3
	dev-libs/libxml2
	x11-libs/libxcb
	sys-apps/dbus
	>=dev-libs/gobject-introspection-1.30.0
	>=dev-lang/vala-0.16.0:0.16[vapigen]"
RDEPEND="${DEPEND}
	bash-completion? ( app-shells/bash )
	gnome-shell? ( >gnome-base/gnome-shell-3.3.2 )
	zsh-completion? ( app-shells/zsh app-shells/zsh-completion )"

WANT_AUTOMAKE="1.12"

G2CONF="
	VALAC=$(type -p valac-0.16)
	VAPIGEN=$(type -p vapigen-0.16)
	--disable-schemas-compile
	$(use_enable applet)
	$(use_enable gnome-shell gnome-shell-extension)"

DOCS="AUTHORS NEWS ChangeLog ChangeLog.pre2.2.1 TODO THANKS README"

REQUIRED_USE="|| ( gnome-shell applet )"

src_install() {
	use bash-completion && dobashcomp data/completions/gpaste
	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins data/completions/_gpaste
	fi
	gnome2_src_install
	find ${D} -name '*.la' -exec rm -f {} +
}
