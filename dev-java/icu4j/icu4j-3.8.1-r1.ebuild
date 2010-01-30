# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2 java-osgi

DESCRIPTION="ICU4J is a set of Java libraries providing Unicode and Globalization support."
MY_PV=${PV//./_}

SRC_URI="http://download.icu-project.org/files/${PN}/${PV}/${PN}-${MY_PV}-src.jar
	doc? ( http://download.icu-project.org/files/${PN}/${PV}/${PN}-${MY_PV}-docs.jar )"

HOMEPAGE="http://www.icu-project.org/"
LICENSE="icu"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

RDEPEND=">=virtual/jre-1.4"

DEPEND="
	|| ( =virtual/jdk-1.6* =virtual/jdk-1.5* =virtual/jdk-1.4* )
	app-arch/unzip"

IUSE="doc"

S="${WORKDIR}"

src_unpack() {
	jar -xf "${DISTDIR}/${PN}-${MY_PV}-src.jar" || die "Failed to unpack"

	if use doc; then
		mkdir docs; cd docs
		jar -xf "${DISTDIR}/${PN}-${MY_PV}-docs.jar" || die "Failed to unpack docs"
	fi
}

src_compile() {
	java-pkg_force-compiler javac
	eant jar || die "Compile failed"
}

src_install() {
	java-osgi_newjar-fromfile --no-auto-version "${PN}.jar" "${FILESDIR}/icu4j-${PV}-manifest" \
		"International Components for Unicode for Java (ICU4J)"
	java-pkg_dojar "${PN}-charsets.jar"

	use doc && dohtml -r readme.html docs/*
	use source && java-pkg_dosrc src/*
}
