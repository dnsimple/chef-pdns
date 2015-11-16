
require 'serverspec'
set :backend, :exec

shared_examples_for 'a PowerDNS server' do
  it 'is running' do
    expect(process('pdns_server')).to(be_running)
  end

  it 'responds to a version query on 53' do
    expect(command('dig @localhost version.bind txt chaos').stdout).to \
      match(/version.bind/).and match(/PowerDNS/)
  end
end
