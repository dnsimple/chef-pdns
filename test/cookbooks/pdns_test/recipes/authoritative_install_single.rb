pdns_authoritative_install 'a-pdns-authoritative' do
  action :install
  version authoritative_version_per_platform
end

pdns_authoritative_service 'a-pdns-authoritative' do
  action [:enable, :start]
end

pdns_authoritative_config 'a-pdns-authoritative' do
  action :create
end
