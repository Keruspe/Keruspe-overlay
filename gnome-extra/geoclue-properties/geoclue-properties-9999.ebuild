# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit distutils git

DESCRIPTION="A Geoclue configuration tool for the end user."
HOMEPAGE="http://git.gnome.org/browse/geoclue-properties/"
SRC_URI=""
EGIT_REPO_URI="git://git.gnome.org/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="gnome-extra/geoclue
	dev-lang/python"

DEPEND="${RDEPEND}"
