include_recipe "pdns::#{node['pdns']['build_method']}"

template '/etc/powerdns/pdns.conf' do
  source 'authoritative.conf.erb'
  owner 'pdns'
  group 'pdns'
  mode '0644'
  notifies :restart, 'service[pdns]', :immediately
end

service 'pdns' do
  action [ :enable, :start ]
end


