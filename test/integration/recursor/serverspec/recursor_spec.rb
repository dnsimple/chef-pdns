require 'spec_helper'

describe 'a PowerDNS recursor' do
  
  it 'is running' do
    expect(process('pdns_recursor')).to(be_running)
  end

  it 'responds to a version query on 53' do
    expect(command('dig @localhost version.bind txt chaos').stdout).to \
      match(/version.bind/).and match(/PowerDNS/)
  end

  it 'can resolve example.com' do
    expect(command('dig @localhost example.com').stdout).to \
      match(/Got answer:/)
  end

end
