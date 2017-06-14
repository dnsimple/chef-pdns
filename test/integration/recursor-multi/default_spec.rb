require File.expand_path('test/libraries/helpers.rb')

describe package('pdns-recursor') do
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

describe processes('pdns_recursor') do
  its ('users') { should eq [default_recursor_run_user, 'another-pdns'] }
end

describe command('dig -p 53 chaos txt version.bind @127.0.0.1 +short') do
  its('stdout.chomp') { should match(/"PowerDNS Recursor 4.0.5/) }
end

describe command('dig -p 54 chaos txt version.bind @127.0.0.1 +short') do
  its('stdout.chomp') { should match(/"PowerDNS Recursor 4.0.5/) }
end

describe command('dig -p 53 @127.0.0.1 dnsimple.com') do
  its('stdout') { should match(/208.93.64.253/) }
end

describe command('dig -p 54 @127.0.0.1 dnsimple.com') do
  its('stdout') { should match(/208.93.64.253/) }
end
