# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
GENTOO_DEPEND_ON_PERL=no
inherit toolchain-funcs eutils elisp-common perl-module bash-completion git

DOC_VER=${PV}

DESCRIPTION="GIT - the stupid content tracker, the revision control system heavily used by the Linux kernel team"
HOMEPAGE="http://www.git-scm.com/"

SRC_URI=""
EGIT_BRANCH="master"
EGIT_REPO_URI="git://git.kernel.org/pub/scm/git/git.git"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="+blksha1 +curl cgi doc emacs gtk iconv +perl ppcsha1 tk +threads +webdav xinetd cvs subversion"

CDEPEND="
	!blksha1? ( dev-libs/openssl )
	sys-libs/zlib
	perl?   ( dev-lang/perl[-build] )
	tk?     ( dev-lang/tk )
	curl?   (
		net-misc/curl
		webdav? ( dev-libs/expat )
	)
	emacs?  ( virtual/emacs )"

RDEPEND="${CDEPEND}
	perl? ( dev-perl/Error
			dev-perl/Net-SMTP-SSL
			dev-perl/Authen-SASL
			cgi? ( virtual/perl-CGI )
			cvs? ( >=dev-vcs/cvsps-2.1 dev-perl/DBI dev-perl/DBD-SQLite )
			subversion? ( dev-vcs/subversion[-dso,perl] dev-perl/libwww-perl dev-perl/TermReadKey )
			)
	gtk?
	(
		>=dev-python/pygtk-2.8
		|| ( dev-python/pygtksourceview:2  dev-python/gtksourceview-python )
	)"

DEPEND="${CDEPEND}
	app-arch/cpio
	doc?    (
		app-text/asciidoc
		app-text/docbook2X
		sys-apps/texinfo
	)
	app-text/asciidoc
	app-text/xmlto"

SITEFILE=50${PN}-gentoo.el

pkg_setup() {
	if ! use perl ; then
		use cgi && ewarn "gitweb needs USE=perl, ignoring USE=cgi"
		use cvs && ewarn "CVS integration needs USE=perl, ignoring USE=cvs"
		use subversion && ewarn "git-svn needs USE=perl, it won't work"
	fi
	if use webdav && ! use curl ; then
		ewarn "USE=webdav needs USE=curl. Ignoring"
	fi
	if use subversion && has_version dev-vcs/subversion && built_with_use --missing false dev-vcs/subversion dso ; then
		ewarn "Per Gentoo bugs #223747, #238586, when subversion is built"
		ewarn "with USE=dso, there may be weird crashes in git-svn. You"
		ewarn "have been warned."
	fi
}

exportmakeopts() {
	local myopts

	if use blksha1 ; then
		myopts="${myopts} BLK_SHA1=YesPlease"
	elif use ppcsha1 ; then
		myopts="${myopts} PPC_SHA1=YesPlease"
	fi

	if use curl ; then
		use webdav || myopts="${myopts} NO_EXPAT=YesPlease"
	else
		myopts="${myopts} NO_CURL=YesPlease"
	fi

	myopts="${myopts} NO_FINK=YesPlease NO_DARWIN_PORTS=YesPlease"
	myopts="${myopts} INSTALL=install TAR=tar"
	myopts="${myopts} SHELL_PATH=${EPREFIX}/bin/sh"
	myopts="${myopts} SANE_TOOL_PATH="
	myopts="${myopts} OLD_ICONV="
	myopts="${myopts} NO_EXTERNAL_GREP="

	sed -i -e '/\/usr\/local/s/BASIC_/#BASIC_/' Makefile

	use iconv \
		|| einfo "Forcing iconv for ${PVR} due to bugs #321895, #322205."
	use !elibc_glibc && myopts="${myopts} NEEDS_LIBICONV=YesPlease"

	use tk \
		|| myopts="${myopts} NO_TCLTK=YesPlease"
	use perl \
		&& myopts="${myopts} INSTALLDIRS=vendor" \
		|| myopts="${myopts} NO_PERL=YesPlease"
	use threads \
		&& myopts="${myopts} THREADED_DELTA_SEARCH=YesPlease"
	use subversion \
		|| myopts="${myopts} NO_SVN_TESTS=YesPlease"

	has_version '>=app-text/asciidoc-8.0' \
		&& myopts="${myopts} ASCIIDOC8=YesPlease"
	myopts="${myopts} ASCIIDOC_NO_ROFF=YesPlease"

	[[ "${CHOST}" == *-uclibc* ]] && \
		myopts="${myopts} NO_NSEC=YesPlease"

	export MY_MAKEOPTS="${myopts}"
}

src_unpack() {
	git_src_unpack
}

src_prepare() {
	sed -i \
		-e 's:^\(CFLAGS =\).*$:\1 $(OPTCFLAGS) -Wall:' \
		-e 's:^\(LDFLAGS =\).*$:\1 $(OPTLDFLAGS):' \
		-e 's:^\(CC = \).*$:\1$(OPTCC):' \
		-e 's:^\(AR = \).*$:\1$(OPTAR):' \
		-e "s:\(PYTHON_PATH = \)\(.*\)$:\1${EPREFIX}\2:" \
		-e "s:\(PERL_PATH = \)\(.*\)$:\1${EPREFIX}\2:" \
		Makefile || die "sed failed"

	sed -i \
		-e '/private-Error.pm/s,^,#,' \
		perl/Makefile.PL

	sed -i 's/DOCBOOK2X_TEXI=docbook2x-texi/DOCBOOK2X_TEXI=docbook2texi.pl/' \
		Documentation/Makefile || die "sed failed"
}

git_emake() {
	emake ${MY_MAKEOPTS} \
		DESTDIR="${ED}" \
		OPTCFLAGS="${CFLAGS}" \
		OPTLDFLAGS="${LDFLAGS}" \
		OPTCC="$(tc-getCC)" \
		OPTAR="$(tc-getAR)" \
		prefix="${EPREFIX}"/usr \
		htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		sysconfdir="${EPREFIX}"/etc \
		"$@"
}

src_configure() {
	exportmakeopts
}

src_compile() {
	git_emake || die "emake failed"

	if use emacs ; then
		elisp-compile contrib/emacs/git{,-blame}.el \
			|| die "emacs modules failed"
	fi

	if use perl && use cgi ; then
		git_emake \
			gitweb/gitweb.cgi \
			|| die "emake gitweb/gitweb.cgi failed"
	fi

	cd "${S}"/Documentation
	git_emake man \
		|| die "emake man failed"
	if use doc ; then
		git_emake info html \
			|| die "emake info html failed"
	fi
}

src_install() {
	git_emake \
		install || \
		die "make install failed"

	find man?/*.[157] >/dev/null 2>&1 && doman man?/*.[157]
	find Documentation/*.[157] >/dev/null 2>&1 && doman Documentation/*.[157]

	dodoc README Documentation/{SubmittingPatches,CodingGuidelines}
	use doc && dodir /usr/share/doc/${PF}/html
	for d in / /howto/ /technical/ ; do
		docinto ${d}
		dodoc Documentation${d}*.txt
		use doc && dohtml -p ${d} Documentation${d}*.html
	done
	docinto /
	use doc && doinfo Documentation/{git,gitman}.info

	dobashcompletion contrib/completion/git-completion.bash ${PN}

	if use emacs ; then
		elisp-install ${PN} contrib/emacs/git.{el,elc} || die
		elisp-install ${PN} contrib/emacs/git-blame.{el,elc} || die
		touch "${ED}${SITELISP}/${PN}/compat/.nosearch"
		elisp-site-file-install "${FILESDIR}"/${SITEFILE} || die
	fi

	if use gtk ; then
		dobin "${S}"/contrib/gitview/gitview
		dodoc "${S}"/contrib/gitview/gitview.txt
	fi

	dobin contrib/fast-import/git-p4
	dodoc contrib/fast-import/git-p4.txt
	newbin contrib/fast-import/import-tars.perl import-tars
	newbin contrib/git-resurrect.sh git-resurrect

	dodir /usr/share/${PN}/contrib
	for i in \
		blameview buildsystems ciabot continuous convert-objects fast-import \
		hg-to-git hooks remotes2config.sh remotes2config.sh rerere-train.sh \
		stats svn-fe vim workdir \
		; do
		cp -rf \
			"${S}"/contrib/${i} \
			"${ED}"/usr/share/${PN}/contrib \
			|| die "Failed contrib ${i}"
	done

	if use perl && use cgi ; then
		exeinto /usr/share/${PN}/gitweb
		doexe "${S}"/gitweb/gitweb.cgi
		insinto /usr/share/${PN}/gitweb/static
		doins "${S}"/gitweb/static/gitweb.css
		js=gitweb.js
		[ -f "${S}"/gitweb/static/gitweb.min.js ] && js=gitweb.min.js
		doins "${S}"/gitweb/static/${js}
		doins "${S}"/gitweb/static/git-{favicon,logo}.png

		docinto /
		newdoc  "${S}"/gitweb/INSTALL INSTALL.gitweb
		newdoc  "${S}"/gitweb/README README.gitweb

		find "${ED}"/usr/lib64/perl5/ \
			-name .packlist \
			-exec rm \{\} \;
	fi
	if ! use subversion ; then
		rm -f "${ED}"/usr/libexec/git-core/git-svn \
			"${ED}"/usr/share/man/man1/git-svn.1*
	fi

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}"/git-daemon.xinetd git-daemon
	fi

	newinitd "${FILESDIR}"/git-daemon.initd git-daemon
	newconfd "${FILESDIR}"/git-daemon.confd git-daemon

	fixlocalpod
}

src_test() {
	local disabled=""
	local tests_cvs="t9200-git-cvsexportcommit.sh \
					t9400-git-cvsserver-server.sh \
					t9401-git-cvsserver-crlf.sh \
					t9600-cvsimport.sh \
					t9601-cvsimport-vendor-branch.sh \
					t9602-cvsimport-branches-tags.sh \
					t9603-cvsimport-patchsets.sh"
	local tests_perl="t5502-quickfetch.sh \
					t5512-ls-remote.sh \
					t5520-pull.sh"
	local tests_nonroot="t0001-init.sh \
		t0004-unwritable.sh \
		t1004-read-tree-m-u-wf.sh \
		t3700-add.sh \
		t7300-clean.sh"

	if ! has_version app-arch/unzip ; then
		einfo "Disabling tar-tree tests"
		disabled="${disabled} t5000-tar-tree.sh"
	fi

	cvs=0
	use cvs && let cvs=$cvs+1
	if [[ ${EUID} -eq 0 ]]; then
		if [[ $cvs -eq 1 ]]; then
			ewarn "Skipping CVS tests because CVS does not work as root!"
			ewarn "You should retest with FEATURES=userpriv!"
			disabled="${disabled} ${tests_cvs}"
		fi
		einfo "Skipping other tests that require being non-root"
		disabled="${disabled} ${tests_nonroot}"
	else
		[[ $cvs -gt 0 ]] && \
			has_version dev-vcs/cvs && \
			let cvs=$cvs+1
		[[ $cvs -gt 1 ]] && \
			built_with_use dev-vcs/cvs server && \
			let cvs=$cvs+1
		if [[ $cvs -lt 3 ]]; then
			einfo "Disabling CVS tests (needs dev-vcs/cvs[USE=server])"
			disabled="${disabled} ${tests_cvs}"
		fi
	fi

	if ! use perl ; then
		einfo "Disabling tests that need Perl"
		disabled="${disabled} ${tests_perl}"
	fi

	cd "${S}/t"
	for i in *.sh.DISABLED ; do
		[[ -f "${i}" ]] && mv -f "${i}" "${i%.DISABLED}"
	done
	einfo "Disabled tests:"
	for i in ${disabled} ; do
		[[ -f "${i}" ]] && mv -f "${i}" "${i}.DISABLED" && einfo "Disabled $i"
	done
	cd "${S}"
	einfo "Start test run"
	git_emake \
		test || die "tests failed"
}

showpkgdeps() {
	local pkg=$1
	shift
	elog "  $(printf "%-17s:" ${pkg}) ${@}"
}

pkg_postinst() {
	use emacs && elisp-site-regen
	if use subversion && has_version dev-vcs/subversion && ! built_with_use --missing false dev-vcs/subversion perl ; then
		ewarn "You must build dev-vcs/subversion with USE=perl"
		ewarn "to get the full functionality of git-svn!"
	fi
	elog "These additional scripts need some dependencies:"
	echo
	showpkgdeps git-quiltimport "dev-util/quilt"
	showpkgdeps git-instaweb \
		"|| ( www-servers/lighttpd www-servers/apache )"
	echo
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
