# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit autotools bash-completion gnome2-live

DESCRIPTION="Clipboard management system"
HOMEPAGE="http://github.com/Keruspe/GPaste"
EGIT_REPO_URI="git://github.com/Keruspe/GPaste.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="applet bash-completion +gnome-shell zsh-completion"

DEPEND="dev-libs/glib:2
	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.40
	>=x11-libs/gtk+-3.0.0:3
	dev-lang/vala:0.14"
RDEPEND="${DEPEND}
	bash-completion? ( app-shells/bash )
	gnome-shell? ( >=gnome-base/gnome-shell-3.1.90 )
	zsh-completion? ( app-shells/zsh app-shells/zsh-completion )"

WANT_AUTOMAKE="1.11"

G2CONF="
	VALAC=$(type -p valac-0.14)
	--disable-schemas-compile
	$(use_enable applet)
	$(use_enable gnome-shell gnome-shell-extension)"

DOCS="AUTHORS NEWS ChangeLog"

src_prepare() {
	gnome2_src_prepare
	if ! has_version gnome-base/gnome-shell; then
		einfo "You do not have gnome-shell installed, building gtk+ applet"
		G2CONF+="--enable-applet"
	fi
}

src_install() {
	use bash-completion && BASHCOMPLETION_NAME="gpaste" dobashcompletion completions/gpaste
	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins completions/_gpaste
	fi
	gnome2_src_install
}
