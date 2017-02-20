pdns_recursor 'a_pdns_recursor' do
  action :install
  version version_per_platform
end

pdns_recursor_service 'a_pdns_recursor' do
  action :enable
end
