pdns_recursor_install 'server-01' do
  action :install
  version recursor_version_per_platform
end

pdns_recursor_config 'server-01' do
  action :create
end

pdns_recursor_service 'server-01' do
  action [:enable, :start]
end

pdns_recursor_install 'server-02' do
  action :install
  version recursor_version_per_platform
end

pdns_recursor_config 'server-02' do
  action :create
  run_user 'another-pdns'
  run_group 'another-pdns'
  run_user_home '/var/lib/another-pdns'
  variables(
    'local-port': '54'
  )
end

pdns_recursor_service 'server-02' do
  action [:enable, :start]
end
