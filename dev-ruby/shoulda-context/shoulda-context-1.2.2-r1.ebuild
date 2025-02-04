# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="CONTRIBUTING.md README.md"

RUBY_FAKEGEM_EXTRAINSTALL="init.rb rails tasks"

# Don't install the conversion script to avoid collisions with older
# shoulda.
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Context framework extracted from Shoulda"
HOMEPAGE="https://github.com/thoughtbot/shoulda-context"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc test"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2
	<dev-ruby/mocha-1 )"

all_ruby_prepare() {
	sed -i -e "1igem 'mocha', '~>0.10'\n" test/test_helper.rb || die
}

each_ruby_test() {
	BUNDLE_GEMFILE=x ruby-ng_testrb-2 -Itest test/shoulda/*_test.rb || die
}
