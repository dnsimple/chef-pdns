cookbook_file '/etc/pdns/bind-backend.conf' do
  source 'bind-backend.conf'
  owner 'root'
  group 'root'
  mode 00755
end
