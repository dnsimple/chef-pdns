require 'spec_helper'

describe 'A PowerDNS Authoritative Server' do
  it 'is running' do
    expect(process('pdns_server')).to be_running
  end
end
