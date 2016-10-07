name             'pdns'
maintainer       'Aetrion, LLC DBA DNSimple'
maintainer_email 'ops@dnsimple.com'
license          'Apache 2.0'
description      'Installs/Configures PowerDNS Recursor and Authoritative server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.4.2'
source_url       'https://github.com/dnsimple/pdns'
issues_url       'https://github.com/dnsimple/pdns/issues'

chef_version '>= 12.1'

supports 'ubuntu', '>= 14.04'

depends 'apt'
depends 'compat_resource', '>= 12.14'
