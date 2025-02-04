# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp font readme.gentoo-r1

DESCRIPTION="Various icon fonts propertized for Emacs"
HOMEPAGE="https://github.com/domtronn/all-the-icons.el/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/domtronn/${PN}.el.git"
else
	if [[ ${PV} == *_p20230316 ]] ; then
		COMMIT=d922aff57ac8308d3ed067f9151cc76d342855f2
		SRC_URI="https://github.com/domtronn/${PN}.el/archive/${COMMIT}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/${PN}.el-${COMMIT}
	else
		SRC_URI="https://github.com/domtronn/${PN}.el/archive/${PV}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/${PN}.el-${PV}
	fi
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( app-emacs/f )"

DOC_CONTENTS="You may need to install the required fonts by executing
	the \"all-the-icons-install-fonts\" function."
DOCS=( README.md logo.png )
SITEFILE="50${PN}-gentoo.el"

pkg_setup() {
	elisp_pkg_setup
	font_pkg_setup
}

src_compile() {
	elisp_src_compile
	elisp-compile data/*.el
}

src_test() {
	${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS}                     \
		-L . -L data -L test -l test/all-the-icons-test.el      \
		-f ert-run-tests-batch-and-exit || die "tests failed"
}

src_install() {
	elisp_src_install
	elisp-install ${PN}/data data/*.el{,c}

	# Install all-the-icons.ttf, special font made explicitly for this library.
	# NOTICE: "fonts" directory also contains some bundled fonts,
	# that is why we need this small re-implementation of font eclass,
	# to suit this specific use case.
	pushd "${S}"/fonts >/dev/null || die
	insinto ${FONTDIR}
	doins ${PN}.ttf
	font_xfont_config
	font_fontconfig
	popd >/dev/null || die
}

pkg_postinst() {
	elisp_pkg_postinst
	font_pkg_postinst
}

pkg_postrm() {
	elisp_pkg_postrm
	font_pkg_postrm
}
