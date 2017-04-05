require File.expand_path('test/libraries/helpers.rb')

describe package('pdns-server') do
  it { should be_installed }
end

describe package('pdns-backend-pgsql') do
  it { should be_installed }
end

describe port(53) do
  it { should be_listening }
  its('processes') { should match(['pdns_server-a']) }
end

describe user(default_run_user) do
  it { should exist }
end

describe group(default_run_user) do
  it { should exist }
end

describe processes('pdns_server-authoritative-server-01-instance') do
  its ('users') { should eq [default_run_user] }
end

describe command('dig chaos txt version.bind @127.0.0.1 +short') do
  its('stdout.chomp') { should match(/"PowerDNS Authoritative Server 4.0.3/) }
end

describe command('dig @127.0.0.1 smoke.example.org') do
  its('stdout.chomp') { should match(/127.0.0.123/) }
end
