# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/broadcom-sta/broadcom-sta-5.60.48.36-r1.ebuild,v 1.3 2010/08/01 14:16:08 hwoarang Exp $

EAPI="2"
inherit eutils linux-mod

DESCRIPTION="Broadcom's IEEE 802.11a/b/g/n hybrid Linux device driver."
HOMEPAGE="http://www.broadcom.com/support/802.11/linux_sta.php"
SRC_BASE="http://www.broadcom.com/docs/linux_sta/hybrid-portsrc_x86-"
SRC_URI="x86? ( ${SRC_BASE}32_v${PV}.tar.gz )
	amd64? ( ${SRC_BASE}64_v${PV}.tar.gz )"

LICENSE="Broadcom"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="mirror"

DEPEND=">=virtual/linux-sources-2.6.22"
RDEPEND=""

S="${WORKDIR}"

MODULE_NAMES="wl(net/wireless)"
MODULESD_WL_ALIASES=("wlan0 wl")

PROPERTIES="interactive"

pkg_setup() {
	check_license

	# bug #300570
	# NOTE<lxnay>: module builds correctly anyway with b43 and SSB enabled
	# make checks non-fatal. The correct fix is blackisting ssb and, perhaps
	# b43 via udev rules. Moreover, previous fix broke binpkgs support.
	CONFIG_CHECK="~!B43 ~!SSB"
	if kernel_is ge 2 6 33; then
		CONFIG_CHECK="${CONFIG_CHECK} LIB80211 WIRELESS_EXT CFG80211_WEXT WEXT_PRIV ~!MAC80211"
		ERROR_WEXT_PRIV="Starting with 2.6.33, it is not possible to set WEXT_PRIV directly. We recommend to set another symbol selecting WEXT_PRIV, for example, PRISM54, IPW2200 and so on. See Bug #248450 comment#98."
	elif kernel_is ge 2 6 31; then
		CONFIG_CHECK="${CONFIG_CHECK} LIB80211 WIRELESS_EXT ~!MAC80211"
	elif kernel_is ge 2 6 29; then
		CONFIG_CHECK="${CONFIG_CHECK} LIB80211 WIRELESS_EXT ~!MAC80211 COMPAT_NET_DEV_OPS"
	else
		CONFIG_CHECK="${CONFIG_CHECK} IEEE80211 IEEE80211_CRYPT_TKIP"
	fi
	linux-mod_pkg_setup

	BUILD_PARAMS="-C ${KV_DIR} M=${S}"
	BUILD_TARGETS="wl.ko"
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-5.10.91.9-license.patch" \
		"${FILESDIR}/${PN}-5.10.91.9.3-linux-2.6.33.patch" 
}
