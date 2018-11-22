pdns_authoritative_install 'default'

pdns_authoritative_config 'default'

config_dir = case node['platform_family']
             when 'debian'
               '/etc/powerdns'
             when 'rhel'
               '/etc/pdns'
             end

pdns_authoritative_config 'server_02' do
  virtual true
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
  virtual true
  action :restart
end
