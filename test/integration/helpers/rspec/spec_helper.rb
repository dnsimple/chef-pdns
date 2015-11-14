#
# The fixtures referenced by these examples can be found in
# the 'test::records' recipe:
#
# test/fixtures/cookbooks/test/recipes/records.rb
#

require 'rspec'
require 'rspec-dns'

RSpec.configure do |c|
  c.add_formatter 'documentation'
end

shared_examples_for 'an authoritative server for test.example' do

  it 'has a test.example SOA record' do
    expect('test.example').to have_dns
      .with_type('SOA')
      .with_name('test.example')
      .with_rname('hostmaster.test.example')
      .with_mname('ns1.test.example')
      .config(nameserver: '127.0.0.1')
  end

  it 'has a test.example MX record' do
    expect('test.example').to have_dns
      .with_type('MX')
      .with_exchange('mail.test.example')
      .with_preference('50')
      .config(nameserver: '127.0.0.1')
  end
  
  it 'has a mail.test.example A record' do
    expect('mail.test.example').to have_dns
      .with_type('A')
      .with_address('10.0.101.11')
      .config(nameserver: '127.0.0.1')
  end

  it 'has an ns1.test.example A record' do
    expect('ns1.test.example').to have_dns
      .with_type('A')
      .config(nameserver: '127.0.0.1')
  end

end
