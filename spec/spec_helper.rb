require 'chefspec'
require 'chefspec/berkshelf'

Dir['libraries/*.rb'].each { |f| require File.expand_path(f) }

RSpec.configure {}

at_exit { ChefSpec::Coverage.report! }
