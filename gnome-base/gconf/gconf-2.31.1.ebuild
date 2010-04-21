# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils gnome2

MY_PN=GConf
MY_P=${MY_PN}-${PV}
PVP=(${PV//[-\._]/ })

DESCRIPTION="Gnome Configuration System and Daemon"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="mirror://gnome/sources/${MY_PN}/${PVP[0]}.${PVP[1]}/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc introspection ldap policykit"

RDEPEND=">=dev-libs/glib-2.25.1
	>=x11-libs/gtk+-2.14
	>=dev-libs/dbus-glib-0.74
	>=sys-apps/dbus-1
	>=gnome-base/orbit-2.4
	>=dev-libs/libxml2-2
	ldap? ( net-nds/openldap )
	introspection? ( dev-libs/gobject-introspection )
	policykit? ( sys-auth/polkit )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	>=dev-util/gtk-doc-am-1.10
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-gtk
		--disable-static
		$(use_enable introspection)
		$(use_with ldap openldap)
		$(use_enable policykit defaults-service)"
	kill_gconf

	export EXTRA_EMAKE="${EXTRA_EMAKE} ORBIT_IDL=/usr/bin/orbit-idl-2"
}

src_prepare() {
	gnome2_src_prepare

	epatch "${FILESDIR}/${PN}-2.24.0-no-gconfd.patch"
	epatch "${FILESDIR}/${PN}-2.28.0-entry-set-value-sigsegv.patch"

	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in || die "sed failed"
}

src_install() {
	gnome2_src_install

	keepdir /etc/gconf/gconf.xml.mandatory
	keepdir /etc/gconf/gconf.xml.defaults
	keepdir /etc/gconf/gconf.xml.system

	echo 'CONFIG_PROTECT_MASK="/etc/gconf"' > 50gconf
	doenvd 50gconf || die "doenv failed"
	dodir /root/.gconfd
}

pkg_preinst() {
	kill_gconf
}

pkg_postinst() {
	kill_gconf

	einfo "changing permissions for gconf dirs"
	find  /etc/gconf/ -type d -exec chmod ugo+rx "{}" \;

	einfo "changing permissions for gconf files"
	find  /etc/gconf/ -type f -exec chmod ugo+r "{}" \;
}

kill_gconf() {
	if [ -x /usr/bin/gconftool-2 ]
	then
		/usr/bin/gconftool-2 --shutdown
	fi

	return 0
}
