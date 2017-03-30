pdns_authoritative_install 'a-pdns-authoritative' do
  action :install
  version authoritative_version_per_platform
end

pdns_authoritative_service 'a-pdns-authoritative' do
  action :enable
end

pdns_authoritative_config 'a-pdns-authoritative' do
  action :create
end

pdns_authoritative_service 'a-pdns-authoritative' do
  action :restart
end

pdns_authoritative_install 'another-pdns-authoritative' do
  action :install
  version authoritative_version_per_platform
end

pdns_authoritative_service 'another-pdns-authoritative' do
  action :enable
end

pdns_authoritative_config 'another-pdns-authoritative' do
  action :create
  run_user 'another-pdns'
  run_group 'another-pdns'
  run_user_home '/var/lib/another-pdns'
  variables(
    'local-port': '54'
  )
end

pdns_authoritative_service 'another-pdns-authoritative' do
  action :restart
end
