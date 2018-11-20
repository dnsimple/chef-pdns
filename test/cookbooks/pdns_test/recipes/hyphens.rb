pdns_authoritative_config 'with-hyphen' do
  instance_name 'with-hyphen'
  action :create
end

pdns_authoritative_service 'with-hyphen' do
  instance_name 'with-hyphen'
  action :enable
end

pdns_recursor_config 'with-hyphen' do
  instance_name 'with-hyphen'
  action :create
end

pdns_recursor_service 'with-hyphen' do
  instance_name 'with-hyphen'
  action :enable
end
