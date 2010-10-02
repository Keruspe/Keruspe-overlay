# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit gnome.org flag-o-matic eutils libtool virtualx

DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="aqua cups debug doc +introspection jpeg jpeg2k tiff test vim-syntax xinerama"

RDEPEND="!aqua? (
		x11-libs/libXrender
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXt
		x11-libs/libXext
		>=x11-libs/libXrandr-1.3
		x11-libs/libXcursor
		x11-libs/libXfixes
		x11-libs/libXcomposite
		x11-libs/libXdamage
		>=x11-libs/cairo-1.9.10[X,svg]
		x11-libs/gdk-pixbuf[X,introspection?,jpeg?,jpeg2k?,tiff?]
	)
	aqua? (
		>=x11-libs/cairo-1.9.10[aqua,svg]
		x11-libs/gdk-pixbuf[introspection?,jpeg?,jpeg2k?,tiff?]
	)
	xinerama? ( x11-libs/libXinerama )
	>=dev-libs/glib-2.25.9
	>=x11-libs/pango-1.20[introspection?]
	>=dev-libs/atk-1.29.2[introspection?]
	media-libs/fontconfig
	x11-misc/shared-mime-info
	cups? ( net-print/cups )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	!<gnome-base/gail-1000"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	!aqua? (
		x11-proto/xextproto
		x11-proto/xproto
		x11-proto/inputproto
		x11-proto/damageproto
	)
	x86-interix? (
		sys-libs/itx-bind
	)
	xinerama? ( x11-proto/xineramaproto )
	>=dev-util/gtk-doc-am-1.11
	doc? (
		>=dev-util/gtk-doc-1.11
		~app-text/docbook-xml-dtd-4.1.2 )
	test? (
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc )"
PDEPEND="vim-syntax? ( app-vim/gtk-syntax )"

src_prepare() {
	replace-flags -O3 -O2
	strip-flags

	sed 's:\(g_test_add_func ("/ui-tests/keys-events.*\):/*\1*/:g' \
		-i gtk/tests/testing.c || die "sed 1 failed"
	sed '\%/recent-manager/add%,/recent_manager_purge/ d' \
		-i gtk/tests/recentmanager.c || die "sed 2 failed"
}

src_configure() {
	local myconf="$(use_enable doc gtk-doc)
		$(use_enable xinerama)
		$(use_enable cups cups auto)
		$(use_enable introspection)
		--disable-papi"
	if use aqua; then
		myconf="${myconf} --with-gdktarget=quartz"
	else
		myconf="${myconf} --with-gdktarget=x11 --with-xinput"
	fi

	use debug && myconf="${myconf} --enable-debug=yes"
	econf --libdir="${EPREFIX}/usr/$(get_libdir)" ${myconf}
}

src_compile() {
	use introspection && export MAKEOPTS="${MAKEOPTS} -j1"
	default
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "tests failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"

	echo 'gtk-fallback-icon-theme = "gnome"' > "${T}/gtkrc"
	insinto /etc/gtk-3.0
	doins "${T}"/gtkrc

	echo "GDK_USE_XFT=1" > "${T}"/50gtk3
	doenvd "${T}"/50gtk3

	dodoc AUTHORS ChangeLog* HACKING NEWS* README* || die "dodoc failed"

	find "${D}" -name "*.la" -delete

	use aqua && for i in gtk+-3.0.pc gtk+-quartz-3.0.pc gtk+-unix-print-3.0.pc; do
		sed -i -e "s:Libs\: :Libs\: -framework Carbon :" "${ED}"usr/$(get_libdir)/pkgconfig/$i || die "sed failed"
	done
}

pkg_postinst() {
	local GTK3_MODDIR="${EROOT}usr/$(get_libdir)/gtk-3.0/3.0.0"
	if [[ -d ${GTK3_MODDIR} ]]; then
		gtk-query-immodules-3.0      > "${GTK3_MODDIR}/immodules.cache"
	else
		ewarn "The destination path ${GTK3_MODDIR} doesn't exist;"
		ewarn "to complete the installation of GTK+, please create the"
		ewarn "directory and then manually run:"
		ewarn "  cd ${GTK3_MODDIR}"
		ewarn "  gtk-query-immodules-3.0      > immodules.cache"
	fi

	elog "Please install app-text/evince for print preview functionality."
	elog "Alternatively, check \"gtk-print-preview-command\" documentation and"
	elog "add it to your gtkrc."
}
