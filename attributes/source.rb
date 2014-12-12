default['pdns']['source']['backends'] = %w( pipe gpgsql gmysql )
default['pdns']['source']['reference'] = 'auth-3.4.1'
default['pdns']['source']['config_dir'] = node['pdns']['authoritative']['config_dir']
