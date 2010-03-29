# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome2

DESCRIPTION="Offical plugins for gedit."
HOMEPAGE="http://live.gnome.org/GeditPlugins"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="bookmarks +bracketcompletion charmap colorpicker +drawspaces +joinlines +session showtabbar smartspaces terminal"

RDEPEND=">=x11-libs/gtk+-2.14
		gnome-base/gconf
		>=x11-libs/gtksourceview-2.6
		>=app-editors/gedit-2.29.8[python]
		>=dev-python/pygtk-2.14
		>=dev-python/pygtksourceview-2.2.0
		charmap? (
			>=gnome-extra/gucharmap-2.24.3
		)
		session? (
			dev-lang/python[xml]
		)
		terminal? (
			>=x11-libs/vte-0.19.4[python]
		)"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

DOCS="AUTHORS NEWS"

pkg_setup()
{
	local myplugins="codecomment,multiedit,wordcompletion"

	for plugin in ${IUSE/python}; do
		if use session && [ "${plugin/+}" = "session" ]; then
			myplugins="${myplugins},sessionsaver"
		elif use ${plugin/+}; then
			myplugins="${myplugins},${plugin/+}"
		fi
	done

	G2CONF="${G2CONF}
		--disable-dependency-tracking
		--with-plugins=${myplugins}
		--enable-python"
}

src_test() {
	emake check || die "make check failed"
}
