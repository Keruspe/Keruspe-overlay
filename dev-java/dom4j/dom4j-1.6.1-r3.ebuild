# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java library for working with XML"
HOMEPAGE="http://dom4j.sourceforge.net/"
SRC_URI="mirror://sourceforge/dom4j/${P}.tar.gz
	mirror://gentoo/${P}-java5.patch.bz2"
LICENSE="dom4j"
SLOT="1"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86 ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris"
IUSE=""
RDEPEND=">=virtual/jre-1.4
	dev-java/jaxme:0
	dev-java/jsr173:0
	>=dev-java/msv-20050627-r2:0
	dev-java/xpp2:0
	dev-java/xpp3:0
	dev-java/relaxng-datatype:0
	dev-java/xerces:2
	>=dev-java/xsdlib-20050627-r2:0
	dev-java/xml-commons-external:1.3"
DEPEND="
	>=virtual/jdk-1.5
	dev-java/ant-junit:0
	dev-java/xalan:0
	dev-java/junitperf:0
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}/${P}-java5.patch"

	rm -v ./src/test/org/dom4j/bean/BeansTest.java || die
	rm -v *.jar || die
	cd "${S}/lib"
	rm -f $(echo *.jar | sed 's/jaxen[^ ]\+//')
	java-pkg_jar-from jaxme
	java-pkg_jar-from jsr173
	java-pkg_jar-from msv
	java-pkg_jar-from xpp2
	java-pkg_jar-from xpp3
	java-pkg_jar-from relaxng-datatype
	java-pkg_jar-from xsdlib
	java-pkg_jar-from xml-commons-external-1.3

	cd "${S}/lib/endorsed"
	rm -v *.jar || die
	java-pkg_jar-from xerces-2 || die

	rm -vr "${S}"/lib/test/* || die
	if use test; then
		java-pkg_jar-from --build-only xalan,junitperf,junit
	fi
	rm -vr "${S}"/lib/tools/* || die
}

EANT_BUILD_TARGET="clean package"
EANT_EXTRA_ARGS="-Dbuild.javadocs=build/doc/api"

src_install() {
	java-pkg_dojar build/${PN}.jar
	use doc && java-pkg_dojavadoc build/doc/api
	use source && java-pkg_dosrc src/java/*
}
