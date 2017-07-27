require File.expand_path('test/libraries/helpers.rb')

describe package(default_authoritative_package) do
  it { should be_installed }
end

describe port(53) do
  it { should be_listening }
  its('processes') { should match([/pdns_server/]) }
end

describe port(54) do
  it { should be_listening }
  its('processes') { should match([/pdns_server/]) }
end

describe user(default_authoritative_run_user) do
  it { should exist }
end

describe group(default_authoritative_run_user) do
  it { should exist }
end

if service('pdns_server').type == 'systemd'
  describe processes(Regexp.new(/pdns_server\s(?!--config-name=server_02)/)) do
    its('users') { should eq ['pdns'] }
  end

  describe processes(Regexp.new(/pdns_server\s(?=--config-name=server_02)/)) do
    its('users') { should eq ['another-pdns'] }
  end
else
  describe processes(Regexp.new(/pdns_server-instance\s(?!--config-name=server_02)/)) do
    its('users') { should eq ['pdns'] }
  end

  describe processes(Regexp.new(/pdns_server-server_02-instance\s(?=--config-name=server_02)/)) do
    its('users') { should eq ['another-pdns'] }
  end
end

describe command('dig -p 53 chaos txt version.bind @127.0.0.1 +short') do
  its('stdout.chomp') { should match(/"PowerDNS Authoritative Server 4\.\d\.\d/) }
end

describe command('dig -p 54 chaos txt version.bind @127.0.0.1 +short') do
  its('stdout.chomp') { should match(/"PowerDNS Authoritative Server 4\.\d\.\d/) }
end
