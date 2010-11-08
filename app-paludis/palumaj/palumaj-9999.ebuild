# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit git

DESCRIPTION="Tool to keep your Gentoo/GNU/Linux up to date using cave"
HOMEPAGE="https://github.com/Keruspe/palumaj"
SRC_URI=""
EGIT_REPO_URI="git://github.com/Keruspe/palumaj"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/paludis"
RDEPEND="${DEPEND}"

src_install() {
	dosbin ${S}/palumaj 
}
