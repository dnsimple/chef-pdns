config_dir = ::Pdns::PdnsAuthoritativeHelpers.default_authoritative_config_directory(node['platform_family'])

pdns_authoritative_install 'server_01' do
  action :install
end

pdns_authoritative_service 'server_01' do
  action :enable
end

pdns_authoritative_config 'server_01' do
  action :create
end

pdns_authoritative_install 'server_02' do
  action :install
end

pdns_authoritative_service 'server_02' do
  action :enable
end

pdns_authoritative_config 'server_02' do
  action :create
  run_user 'another-pdns'
  run_group 'another-pdns'
  run_user_home '/var/lib/another-pdns'
  variables(
    'local-port' => '54',
    'bind_config' => "#{config_dir}/bindbackend.conf"
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
  mode '0750'
end

file "#{config_dir}/example.org.zone" do
  content test_zone
  owner 'pdns'
  group 'pdns'
  mode '0750'
end

pdns_authoritative_service 'server_01' do
  action :start
end

pdns_authoritative_service 'server_02' do
  action :start
end
