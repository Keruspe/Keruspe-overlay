# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit bash-completion gnome2

DESCRIPTION="Clipboard management system"
HOMEPAGE="http://github.com/Keruspe/GPaste"
SRC_URI="https://github.com/downloads/Keruspe/${PN/gp/GP}/${P}.tar.xz"
RESTRICT="nomirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="applet bash-completion +gnome-shell zsh-completion"

DEPEND="dev-libs/glib:2
	>=sys-devel/gettext-0.17
	>=dev-util/intltool-0.40
	>=x11-libs/gtk+-3.0.0:3"
RDEPEND="${DEPEND}
	bash-completion? ( app-shells/bash )
	gnome-shell? ( >=gnome-base/gnome-shell-3.1.90 )
	zsh-completion? ( app-shells/zsh app-shells/zsh-completion )"

G2CONF="
	--disable-schemas-compile
	$(use_enable applet)
	$(use_enable gnome-shell gnome-shell-extension)"

DOCS="AUTHORS NEWS ChangeLog"

REQUIRED_USE="|| ( gnome-shell applet )"

src_install() {
	use bash-completion && BASHCOMPLETION_NAME="gpaste" dobashcompletion completions/gpaste
	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins completions/_gpaste
	fi
	gnome2_src_install
}
