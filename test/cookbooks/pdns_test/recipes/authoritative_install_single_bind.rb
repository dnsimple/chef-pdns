pdns_authoritative_install 'server-01' do
  action :install
  version authoritative_version_per_platform
end

pdns_authoritative_service 'server-01' do
  action :enable
end

pdns_authoritative_config 'server-01' do
  action :create
end

test_zonefile = <<-EOF
zone "example.org" { type master; file "/etc/powerdns/example.org.zone"; };
EOF

test_zone = <<-EOF
example.org.           172800  IN      SOA     ns1.example.org. dns.example.org. 1 10800 3600 604800 3600
example.org.           172800  IN      NS      ns1.example.org.
smoke.example.org.     172800  IN      A       127.0.0.123
EOF

cookbook_file '/etc/powerdns/bindbackend.conf' do
  source test_zonefile
  owner 'group'
  group 'group'
  mode '0750'
end

cookbook_file '/etc/powerdns/example.org.zone' do
  source test_zone
  owner 'group'
  group 'group'
  mode '0750'
end

pdns_authoritative_service 'server-01' do
  action :restart
end
