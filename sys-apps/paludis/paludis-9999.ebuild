# Copyright 1999-2010 Ciaran McCreesh
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="paludis-1"

SCM_REPOSITORY="git://git.pioto.org/paludis.git"
SCM_CHECKOUT_TO="${DISTDIR}/git-src/paludis"
inherit scm-git bash-completion eutils flag-o-matic

DESCRIPTION="paludis, the other package mangler"
HOMEPAGE="http://paludis.pioto.org/"
SRC_URI=""

IUSE="ask cave cran doc gems inquisitio portage pink python-bindings
ruby-bindings sort-world vim-syntax visibility xml zsh-completion"
LICENSE="GPL-2 vim-syntax? ( vim )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	>=app-admin/eselect-1.2_rc1
	>=app-shells/bash-3.2
	inquisitio? ( dev-libs/libpcre[cxx] )
	ruby-bindings? ( >=dev-lang/ruby-1.8 )
	python-bindings? ( >=dev-lang/python-2.6:= >=dev-libs/boost-1.41.0[python] )
	gems? ( >=dev-libs/syck-0.55 virtual/rubygems )
	xml? ( >=dev-libs/libxml2-2.6 )"

DEPEND="${COMMON_DEPEND}
	sys-devel/autoconf:2.5
	sys-devel/automake:1.11
	doc? (
		|| ( >=app-doc/doxygen-1.5.3 <=app-doc/doxygen-1.5.1 )
		media-gfx/imagemagick
		python-bindings? ( dev-python/epydoc dev-python/pygments )
		ruby-bindings? ( dev-ruby/syntax dev-ruby/allison )
	)
	dev-util/pkgconfig"

RDEPEND="${COMMON_DEPEND}
	sys-apps/sandbox"

# Keep syntax as a PDEPEND. It avoids issues when Paludis is used as the
# default virtual/portage provider.
PDEPEND="
	vim-syntax? ( >=app-editors/vim-core-7 )
	suggested:
		dev-vcs/git
		dev-util/subversion
		dev-util/cvs
		dev-vcs/darcs
		net-misc/rsync
		net-misc/wget"

PROVIDE="virtual/portage"

create-paludis-user() {
	enewgroup "paludisbuild"
	enewuser "paludisbuild" -1 -1 "/var/tmp/paludis" "paludisbuild"
}

pkg_setup() {
	create-paludis-user
	replace-flags -Os -O2
}

src_unpack() {
	scm_src_unpack
	cd "${S}"
	use ask && epatch ${FILESDIR}/paludis-ask.patch
	use sort-world && epatch ${FILESDIR}/paludis-sort-world.patch
	./autogen.bash || die "autogen.bash failed"
}

src_compile() {
	local repositories=`echo default unavailable unpackaged $(usev cran ) $(usev gems ) | tr -s \  ,`
	local clients=`echo default accerso appareo adjutrix importare \
		$(usev inquisitio ) instruo paludis reconcilio $(usev cave) | tr -s \  ,`
	local environments=`echo default $(usev portage ) | tr -s \  ,`
	econf \
		$(use_enable doc doxygen ) \
		$(use_enable pink ) \
		$(use_enable ruby-bindings ruby ) \
		$(useq ruby-bindings && useq doc && echo --enable-ruby-doc ) \
		$(use_enable python-bindings python ) \
		$(useq python-bindings && useq doc && echo --enable-python-doc ) \
		$(use_enable vim-syntax vim ) \
		$(use_enable visibility ) \
		$(use_enable xml ) \
		--with-vim-install-dir=/usr/share/vim/vimfiles \
		--with-repositories=${repositories} \
		--with-clients=${clients} \
		--with-environments=${environments} \
		--with-git-head="$(git rev-parse HEAD)" \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS README NEWS

	BASHCOMPLETION_NAME="adjutrix" dobashcompletion bash-completion/adjutrix
	BASHCOMPLETION_NAME="paludis" dobashcompletion bash-completion/paludis
	BASHCOMPLETION_NAME="accerso" dobashcompletion bash-completion/accerso
	BASHCOMPLETION_NAME="importare" dobashcompletion bash-completion/importare
	BASHCOMPLETION_NAME="instruo" dobashcompletion bash-completion/instruo
	BASHCOMPLETION_NAME="reconcilio" dobashcompletion bash-completion/reconcilio
	use inquisitio && \
		BASHCOMPLETION_NAME="inquisitio" \
		dobashcompletion bash-completion/inquisitio
	use cave && \
		BASHCOMPLETION_NAME="cave" \
		dobashcompletion bash-completion/cave

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins zsh-completion/_paludis
		doins zsh-completion/_adjutrix
		doins zsh-completion/_cave
		doins zsh-completion/_importare
		doins zsh-completion/_reconcilio
		use inquisitio && doins zsh-completion/_inquisitio
		doins zsh-completion/_paludis_packages
		use cave && doins zsh-completion/_cave
	fi
}

src_test() {
	# Work around Portage bugs
	export PALUDIS_DO_NOTHING_SANDBOXY="portage sucks"
	export BASH_ENV=/dev/null

	if [[ `id -u` == 0 ]] ; then
		# hate
		export PALUDIS_REDUCED_UID=0
		export PALUDIS_REDUCED_GID=0
	fi

	if ! emake check ; then
		eerror "Tests failed. Looking for files for you to add to your bug report..."
		find "${S}" -type f -name '*.epicfail' -or -name '*.log' | while read a ; do
			eerror "    $a"
		done
		die "Make check failed"
	fi
}

pkg_postinst() {
	# Remove the symlink created by app-admin/eselect-news
	if [[ -L "${ROOT}/var/lib/paludis/news" ]] ; then
		rm "${ROOT}/var/lib/paludis/news"
	fi
}

