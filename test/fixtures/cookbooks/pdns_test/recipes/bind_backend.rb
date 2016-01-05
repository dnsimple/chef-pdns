template '/etc/powerdns/bind-backend.conf' do
  source 'bind-backend.conf.erb'
  owner 'pdns'
  group 'pdns'
  mode 00755
end
