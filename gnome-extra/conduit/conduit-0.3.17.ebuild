# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit python gnome2 multilib

DESCRIPTION="Synchronization for GNOME"
HOMEPAGE="http://www.conduit-project.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="eog nautilus totem"

DEPEND="sys-apps/dbus
	>=dev-python/pygoocanvas-0.9.0
	>=dev-python/vobject-0.4.8
	>=dev-python/pyxml-0.8.4
	>=dev-python/pygtk-2.10.3
	>=dev-python/pysqlite-2.3.1
	>=dev-python/pygoocanvas-0.9.0
	eog? ( media-gfx/eog[python] )
	nautilus? ( gnome-base/nautilus )
	totem? ( media-video/totem[python] )"
RDEPEND="${DEPEND}"

src_prepare() {
	rm py-compile
	ln -s $(type -P true) "${S}"/py-compile

	gnome2_src_prepare
}

G2CONF="\
	$(use_enable nautilus nautilus-extension) \
	$(use_enable eog eog-plugin) \
	$(use_enable totem totem-plugin)"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/conduit/modules/
	python_mod_optimize conduit
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/conduit/modules/
	python_mod_cleanup conduit
}
