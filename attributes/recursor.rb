default['pdns']['recursor']['config_dir'] = '/etc/pdns'
default['pdns']['recursor']['allow_from'] = [
  '127.0.0.0/8',
  '10.0.0.0/8',
  '192.168.0.0/16',
  '172.16.0.0/12',
  '::1/128',
  'e80::/10'
]
default['pdns']['recursor']['auth_zones'] = []
default['pdns']['recursor']['forward_zones'] = []
default['pdns']['recursor']['forward_zones_recurse'] = []
default['pdns']['recursor']['local_address'] = [node['ipaddress']]
default['pdns']['recursor']['local_port'] = '53'
