# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit python autotools

DESCRIPTION="A printer administration tool"
HOMEPAGE="http://cyberelk.net/tim/software/system-config-printer/"
SRC_URI="http://cyberelk.net/tim/data/${PN}/1.2/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome-keyring"

COMMON_DEPEND="
	dev-lang/python
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/xmlto
	dev-util/intltool
	virtual/libintl
"
RDEPEND="${COMMON_DEPEND}
	dev-libs/libxml2[python]
	dev-python/notify-python
	dev-python/dbus-python
	dev-python/pycups
	dev-python/pygobject
	>=dev-python/pygtk-2.13
	dev-python/pyxml
	net-print/cups[dbus]
	gnome-keyring? ( dev-python/gnome-keyring-python )
"

APP_LINGUAS="ar as bg bn bn_IN bs ca cs cy da de el en_GB es et fa fi fr gu he hi
hr hu hy id is it ja ka kn ko lo lv mk ml mr ms nb nl nn or pa pl pt pt_BR ro ru
si sk sl sr sv ta te th tr uk vi zh_CN"
for X in ${APP_LINGUAS}; do
	IUSE="${IUSE} linguas_${X}"
done

src_configure() {
	local myconf
	if [[ -z "${LINGUAS}" ]]; then
		myconf="${myconf} --disable-nls"
	else
		myconf="${myconf} --enable-nls"
	fi
	econf ${myconf}
}

src_install() {
	dodoc AUTHORS ChangeLog README || die "dodoc failed"
	emake DESTDIR="${D}" install || die "emake install failed"
}
