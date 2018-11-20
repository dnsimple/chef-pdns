# On Ubuntu 18.04 they enable a stub listener by default which conflicts with
# the default PowerDNS install so thanks, systemd (and Ubuntu maintainers)
file '/etc/netplan/99-no_stub_resolver.yaml' do
  content <<-EOF
network:
  version: 2
  ethernets:
    eth0:
      nameservers:
        addresses: [8.8.8.8,8.8.4.4]
  EOF
  mode '0644'
  owner 'root'
  group 'root'
  notifies :run, 'execute[update_netplan]', :immediately
  notifies :stop, 'service[systemd-resolved.service]', :immediately
  notifies :create, 'link[update_resolv]', :immediately
  only_if { node['platform'].include?('ubuntu') && node['platform_version'].to_f >= 18.04 }
end

execute 'update_netplan' do
  command 'netplan apply'
  action :nothing
end

service 'systemd-resolved.service' do
  action :nothing
end

link 'update_resolv' do
  target_file '/etc/resolv.conf'
  to '/run/systemd/resolve/resolv.conf'
  action :nothing
end

pdns_authoritative_install 'default' do
  action :install
end

pdns_authoritative_config 'default_server_01' do
  action :create
end

config_dir = case node['platform_family']
             when 'debian'
               '/etc/powerdns'
             when 'rhel'
               '/etc/pdns'
             end

pdns_authoritative_config 'server_02' do
  instance_name 'server_02'
  run_user 'another-pdns'
  run_group 'another-pdns'
  run_user_home '/var/lib/another-pdns'
  variables(
    'local-port' => '54',
    'bind-config' => "#{config_dir}/bindbackend.conf"
  )
end

group 'pdns' do
  action :modify
  members 'another-pdns'
  append true
end

test_zonefile = <<-EOF
zone "example.org" { type master; file "#{config_dir}/example.org.zone"; };
EOF

test_zone = <<-EOF
example.org.           172800  IN      SOA     ns1.example.org. dns.example.org. 1 10800 3600 604800 3600
example.org.           172800  IN      NS      ns1.example.org.
smoke.example.org.     172800  IN      A       127.0.0.123
EOF

file "#{config_dir}/bindbackend.conf" do
  content test_zonefile
  owner 'pdns'
  group 'pdns'
  mode '0440'
end

file "#{config_dir}/example.org.zone" do
  content test_zone
  owner 'pdns'
  group 'pdns'
  mode '0440'
end

pdns_authoritative_service 'default' do
  action :restart
end

pdns_authoritative_service 'server_02' do
  instance_name 'server_02'
  action :restart
end
