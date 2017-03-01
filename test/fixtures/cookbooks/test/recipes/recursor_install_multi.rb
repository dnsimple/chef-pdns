pdns_recursor_install 'a_pdns_recursor' do
  action :install
  version version_per_platform
end

pdns_recursor_service 'a_pdns_recursor' do
  action :enable
end

pdns_recursor_config 'a_pdns_recursor' do
  action :create
end

pdns_recursor_install 'another_pdns_recursor' do
  action :install
  version version_per_platform
end

pdns_recursor_service 'another_pdns_recursor' do
  action :enable
end

pdns_recursor_config 'another_pdns_recursor' do
  action :create
  run_user 'another-pdns'
  run_group 'another-pdns'
  run_user_home '/var/lib/another-pdns'
  variables(
    'local-port': '54'
  )
end
