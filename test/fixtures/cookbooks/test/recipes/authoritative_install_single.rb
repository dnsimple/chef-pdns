pdns_authoritative_install 'a_pdns_authoritative' do
  action :install
  version authoritative_version_per_platform
end

# pdns_authoritative_service 'a_pdns_authoritative' do
#   action [:enable, :start]
# end

# pdns_authoritative_config 'a_pdns_authoritative' do
#   action :create
# end
