Dir['test/libraries/*.rb'].each { |f| require File.expand_path(f) }

describe package('pdns-recursor') do
  it { should be_installed }
end

describe port(53) do
  it { should be_listening }
  its('processes') { should include 'pdns_recursor' }
end

describe user(default_run_user) do
  it { should exist }
end

describe group(default_run_user) do
  it { should exist }
end

describe processes('pdns_recursor') do
  its ('users') { should eq ["#{default_run_user}"] }
end

describe command('dig @127.0.0.1 dnsimple.com') do
  its('stdout') { should match(/208.93.64.253/) }
end

