require File.expand_path('test/libraries/helpers.rb')

describe package('pdns-recursor') do
  it { should be_installed }
end

describe port(53) do
  it { should be_listening }
  its('processes') { should include 'pdns_recursor' }
end

describe user(default_recusor_run_user) do
  it { should exist }
end

describe group(default_recusor_run_user) do
  it { should exist }
end

describe processes('pdns_recursor') do
  its ('users') { should eq [default_recusor_run_user] }
end

describe command('dig @127.0.0.1 dnsimple.com') do
  its('stdout') { should match(/208.93.64.253/) }
end

