pdns_recursor_install '' do
  action :install
end

pdns_recursor_config '' do
  action :create
end

pdns_recursor_install 'server_02' do
  action :install
  debug true
  version recursor_version_per_platform
end

pdns_recursor_config 'server_02' do
  action :create
  run_user 'another-pdns'
  run_group 'another-pdns'
  run_user_home '/var/lib/another-pdns'
  variables(
    'local-port' => '54'
  )
end

pdns_recursor_service '' do
  action %i[enable start]
end

pdns_recursor_service 'server_02' do
  action %i[enable start]
end
