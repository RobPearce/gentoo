# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Canonical source for classifiers on PyPI (pypi.org)"
HOMEPAGE="
	https://github.com/pypa/trove-classifiers/
	https://pypi.org/project/trove-classifiers/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~sparc ~x86"

BDEPEND="
	dev-python/calver[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	epytest
	"${EPYTHON}" -m tests.lib || die
}
