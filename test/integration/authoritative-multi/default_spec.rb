require File.expand_path('test/libraries/helpers.rb')

describe package('pdns-server') do
  it { should be_installed }
end

describe port(53) do
  it { should be_listening }
  its('processes') { should match(['pdns_server-a']) }
end

describe port(54) do
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

describe processes('pdns_server-authoritative-server-02-instance') do
  its ('users') { should eq ['another-pdns'] }
end

describe command('dig -p 53 chaos txt version.bind @127.0.0.1 +short') do
  its('stdout.chomp') { should match('"PowerDNS Authoritative Server 4.0.3 (built Jan 17 2017 09:06:22 by root@d087975b3e20)"') }
end

describe command('dig -p 54 chaos txt version.bind @127.0.0.1 +short') do
  its('stdout.chomp') { should match('"PowerDNS Authoritative Server 4.0.3 (built Jan 17 2017 09:06:22 by root@d087975b3e20)"') }
end

