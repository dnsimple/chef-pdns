require 'spec_helper'

describe 'A PowerDNS Resolver' do
  it 'is running' do
    expect(process('pdns_recursor')).to be_running
  end

  it 'can resolve example.com' do
    expect(command('dig @localhost example.com').stdout).to \
      match(/Got answer:/)
  end
end
