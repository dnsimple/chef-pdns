name             'pdns'
maintainer       'DNSimple Corp'
maintainer_email 'ops@dnsimple.com'
license          'Apache-2.0'
description      'Installs/Configures PowerDNS Recursor and Authoritative server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '5.0.0'
source_url       'https://github.com/dnsimple/chef-pdns'
issues_url       'https://github.com/dnsimple/chef-pdns/issues'

chef_version '>= 13'

supports 'ubuntu', '>= 14.04'
supports 'debian', '>= 8.0'
supports 'centos', '>= 6.0'
supports 'redhat', '>= 6.0'
