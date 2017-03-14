pdns_recursor_install 'a_pdns_recursor' do
  action :install
  version version_per_platform
end

pdns_recursor_service 'a_pdns_recursor' do
  action [:enable, :start]
end

pdns_recursor_config 'a_pdns_recursor' do
  action :create
end
