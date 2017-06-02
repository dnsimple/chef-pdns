require 'chefspec'
require 'chefspec/berkshelf'

Dir['libraries/*.rb'].each { |f| require File.expand_path(f) }

RSpec.configure { }

def mock_service_resource_providers(hints)
  allow(Chef::Platform::ServiceHelpers).to receive(:service_resource_providers).and_return(hints)
end

at_exit { ChefSpec::Coverage.report! }
