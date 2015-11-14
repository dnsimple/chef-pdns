require 'spec_helper'

describe 'A PowerDNS Resolver' do
  it_behaves_like 'a PowerDNS server'
  
  it 'can resolve example.com' do
    expect(command('dig @localhost example.com').stdout).to \
      match(/Got answer:/)
  end
end
