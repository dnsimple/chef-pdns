pdns_authoritative_install 'server-01' do
  action :install
  version authoritative_version_per_platform
end

pdns_authoritative_service 'server-01' do
  action :enable
end

pdns_authoritative_config 'server-01' do
  action :create
end

pdns_authoritative_service 'server-01' do
  action :restart
end

pdns_authoritative_install 'server-02' do
  action :install
  version authoritative_version_per_platform
end

pdns_authoritative_service 'server-02' do
  action :enable
end

pdns_authoritative_config 'server-02' do
  action :create
  run_user 'another-pdns'
  run_group 'another-pdns'
  run_user_home '/var/lib/another-pdns'
  variables(
    'local-port': '54'
  )
end

pdns_authoritative_service 'server-02' do
  action :restart
end
