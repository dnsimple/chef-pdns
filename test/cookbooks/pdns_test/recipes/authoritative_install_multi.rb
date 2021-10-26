include_recipe 'pdns_test::disable_systemd_resolved'

pdns_authoritative_install 'default' do
  debug true
end

pdns_authoritative_config 'default'

config_dir = case node['platform_family']
             when 'debian'
               '/etc/powerdns'
             when 'rhel'
               '/etc/pdns'
             end

pdns_authoritative_config 'server_02' do
  virtual true
  variables(
    'local-port' => '54',
    'bind-config' => "#{config_dir}/bindbackend.conf"
  )
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
  action [:enable, :restart]
end

pdns_authoritative_service 'server_02' do
  virtual true
  action [:enable, :restart]
end
