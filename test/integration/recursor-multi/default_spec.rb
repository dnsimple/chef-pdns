require File.expand_path('test/libraries/helpers.rb')

describe package('pdns-recursor') do
  it { should be_installed }
end

describe package(default_recursor_debug_package) do
  it { should be_installed }
end

describe port(53) do
  it { should be_listening }
  its('processes') { should include 'pdns_recursor' }
end

describe port(54) do
  it { should be_listening }
  its('processes') { should include 'pdns_recursor' }
end

describe user(default_recursor_run_user) do
  it { should exist }
end

describe group(default_recursor_run_user) do
  it { should exist }
end

describe processes(Regexp.new(/pdns_recursor\s(?!--config)/)) do
  its('users') { should match [Regexp.new(/pdns(-recursor)?/)] }
end

describe processes(Regexp.new(/pdns_recursor --config-name=server_02/)) do
  its('users') { should match [Regexp.new(/pdns/)] }
end

describe command('dig -p 53 chaos txt version.bind @127.0.0.1 +short') do
  its('stdout.chomp') { should match(Regexp.new(/"PowerDNS Recursor 4\.8\.\d/)) }
end

describe command('dig -p 54 chaos txt version.bind @127.0.0.1 +short') do
  its('stdout.chomp') { should match(Regexp.new(/"PowerDNS Recursor 4\.8\.\d/)) }
end

describe command('dig -p 53 @127.0.0.1 dnsimple.com') do
  its('stdout') { should match(Regexp.new(/\d+\.\d+\.\d+\.\d+/)) }
end

describe command('dig -p 54 @127.0.0.1 dnsimple.com') do
  its('stdout') { should match(Regexp.new(/\d+\.\d+\.\d+\.\d+/)) }
end

## Regression test for https://github.com/dnsimple/chef-pdns/issues/89
describe command('rec_control --config-name=server_02 reload-zones') do
  its('stdout') { should match('ok') }
  its('stdout') { should_not match('unable to parse configuration file') }
  its('stdout') { should_not match('Encountered error reloading zones, keeping original data: Unable to re-parse configuration file') }
  its('exit_status') { should eq 0 }
end
