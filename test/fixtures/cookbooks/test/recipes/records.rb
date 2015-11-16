#
# When altering these test fixtures, make sure you update the RSpec
# shared examples in 'test/integration/helpers/rspec/spec_helper.rb'
#

pdns_domain "test.example" do
  soa_email 'hostmaster@test.example'
  soa_ip node[:ipaddress]
end

pdns_record 'test.example' do
  type 'MX'
  domain 'test.example'
  content 'mail.test.example'
  prio 50
end

pdns_record 'mail.test.example' do
  type 'A'
  domain 'test.example'
  content '10.0.101.11'
end
