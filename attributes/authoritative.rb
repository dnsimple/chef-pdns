default['pdns']['authoritative']['allow_recursion'] = [ '127.0.0.1' ]
default['pdns']['authoritative']['config_dir'] = '/etc/powerdns'
default['pdns']['authoritative']['daemon'] = true
default['pdns']['authoritative']['disable_axfr'] = true
default['pdns']['authoritative']['guardian'] = true
default['pdns']['authoritative']['setgid'] = 'pdns'
default['pdns']['authoritative']['setuid'] = 'pdns'
default['pdns']['authoritative']['version_string'] = 'powerdns'

default['pdns']['authoritative']['source']['url'] = 'https://downloads.powerdns.com/releases/pdns-3.4.1.tar.bz2'
default['pdns']['authoritative']['source']['path'] = '/opt'
default['pdns']['authoritative']['source']['backends'] = %w( pipe gpgsql gmysql )

# The backend to launch with the authoritative server
default['pdns']['authoritative']['launch'] = 'gpgsql'
