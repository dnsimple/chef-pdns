require 'serverspec'

set :backend, :exec
set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Require support files
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |file| require_relative(file) }
