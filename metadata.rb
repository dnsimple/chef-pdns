name             'pdns'
maintainer       'Aetrion, LLC DBA DNSimple'
maintainer_email 'ops@dnsimple.com'
license          'Apache 2.0'
description      'Installs/Configures PowerDNS Recursor and Authoritative server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.4.1'
source_url       'https://github.com/dnsimple/pdns' if respond_to?(:source_url)
issues_url       'https://github.com/dnsimple/pdns/issues' if respond_to?(:issues_url)

supports 'ubuntu', '= 12.04'
supports 'ubuntu', '= 14.04'

depends 'build-essential'
depends 'resolvconf'
depends 'database'
depends 'yum-epel'
