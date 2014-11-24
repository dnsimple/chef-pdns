require_relative '../../../kitchen/data/spec_helper.rb'

if os[:family] == 'redhat'
  describe package('pdns') do
    it { should be_installed }
  end
elsif ['debian', 'ubuntu'].include?(os[:family])
  describe package('pdns-server') do
    it { should be_installed }
  end
end

describe service('pdns') do
  it { should be_enabled }
  it { should be_running }
end

describe host('mars.test.loc') do
  its(:ipaddress) { should eq '10.10.10.2' }
end

describe host('venus.test.loc') do
  its(:ipaddress) { should eq '10.10.10.3' }
end
