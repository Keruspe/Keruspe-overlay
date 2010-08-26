# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"

EBZR_REPO_URI="https://code.launchpad.net/~segphault/gwibber/pre-3.0"

inherit bzr eutils distutils

DESCRIPTION="Gwibber is an open source microblogging client for GNOME developed
with Python and GTK."
HOMEPAGE="https://launchpad.net/gwibber"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/dbus-python-0.80.2
	>=dev-python/gconf-python-2.18.0
	>=dev-python/imaging-1.1.6
	>=dev-python/notify-python-0.1.1
	>=dev-python/pywebkitgtk-1.0.1
	>=dev-python/simplejson-1.9.1
	>=dev-python/egenix-mx-base-3.0.0
	>=dev-python/python-distutils-extra-2.15
	>=dev-python/pycurl-7.19.0
	>=dev-python/libwnck-python-2.26.0
	>=dev-python/feedparser-4.1
	>=dev-python/pyxdg-0.15
	>=dev-python/mako-0.2.4
	>=dev-python/pygtk-2.21
	dev-python/oauth
	dev-python/pysqlite
	>=gnome-base/librsvg-2.22.2"

src_install() {
	distutils_src_install

	insinto /usr/share/dbus-1/services
	doins com.Gwibber{.Service,Client}.service || die "Installing services failed."
	doman gwibber{,-poster}.1 || die "Man page couldn't be installed."
}
