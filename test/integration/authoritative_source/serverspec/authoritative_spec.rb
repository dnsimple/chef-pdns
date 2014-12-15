require 'spec_helper'

describe 'A PowerDNS Authoritative Server' do
  it 'is running' do
    expect(process('pdns_server')).to be_running
  end

  it 'can resolve example.com' do
    expect(command('dig @localhost example.com').stdout).to \
      match(/Got answer:/)
  end
end
