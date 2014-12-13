require 'spec_helper'

describe 'A PowerDNS Resolver' do
  it 'is running' do
    expect(process('pdns_recursor')).to be_running
  end
end
