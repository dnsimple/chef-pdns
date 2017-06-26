require File.expand_path('test/libraries/helpers.rb')

describe package(default_authoritative_package) do
  it { should be_installed }
end

describe package(default_authoritative_postgres_backend_package) do
  it { should be_installed }
end

describe port(53) do
  it { should be_listening }
  its('processes') { should match([/pdns_server/]) }
end

describe user(default_authoritative_run_user) do
  it { should exist }
end

describe group(default_authoritative_run_user) do
  it { should exist }
end

describe processes('pdns_server-authoritative_server_01-instance') do
  its ('users') { should eq [default_authoritative_run_user] }
end

describe command('dig chaos txt version.bind @127.0.0.1 +short') do
  its('stdout.chomp') { should match(/"PowerDNS Authoritative Server 4.0.4/) }
end

describe command('dig @127.0.0.1 smoke.example.org') do
  its('stdout.chomp') { should match(/127.0.0.123/) }
end
