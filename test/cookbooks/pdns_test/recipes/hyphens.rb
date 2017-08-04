pdns_authoritative_config 'with-hyphen' do
  action :create
end

pdns_authoritative_service 'with-hyphen' do
  action :enable
end

pdns_recursor_config 'with-hyphen' do
  action :create
end

pdns_recursor_service 'with-hyphen' do
  action :enable
end
