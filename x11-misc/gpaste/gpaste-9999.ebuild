# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools bash-completion gnome2 git

DESCRIPTION="Clipboard management system"
HOMEPAGE="http://github.com/Keruspe/GPaste"
SRC_URI=""
EGIT_REPO_URI="git://github.com/Keruspe/GPaste.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+applet bash-completion zsh-completion"

DEPEND="dev-libs/glib:2
	>=sys-devel/gettext-0.18
	dev-util/intltool
	x11-libs/gtk+:3
	dev-lang/vala:0.12"
RDEPEND="${DEPEND}
	bash-completion? ( app-shells/bash )
	zsh-completion? ( app-shells/zsh )"

WANT_AUTOMAKE="1.11"

G2CONF="$(use_enable applet)"

src_prepare() {
	mkdir m4
	eautoreconf
	intltoolize --force --automake
	gnome2_src_prepare
}

src_install() {
	use bash-completion && BASHCOMPLETION_NAME="gpaste" dobashcompletion completions/gpaste
	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins completions/_gpaste
	fi
	gnome2_src_install
}
