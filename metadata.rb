name             'pdns'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache 2.0'
description      'Installs/Configures pdns'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.2.1'
source_url       'https://github.com/aetrion/pdns' if respond_to?(:source_url)
issues_url       'https://github.com/aetrion/pdns/issues' if respond_to?(:issues_url)

supports 'ubuntu', '= 12.04'
supports 'ubuntu', '= 14.04'

depends 'build-essential'
depends 'resolvconf'
depends 'database'
