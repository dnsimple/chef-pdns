#
# Cookbook Name:: pdns
# Recipe:: backend_clients
#

include_recipe 'apt'
include_recipe 'build-essential'

#
# For Chef 11.x compatibility, it is important to use gem_package
# instead of chef_gem.  Chef 11 does not include the 'compile_time'
# attribute for chef_gem resources.
#
chef_gem_binary = File.join(Chef::Config.embedded_dir,'bin','gem')

gem_package 'sequel' do
  gem_binary chef_gem_binary
end

launch = node['pdns']['authoritative']['config']['launch']

if launch == 'gmysql'  
  gem_package 'mysql2' do
    gem_binary chef_gem_binary
  end
elsif launch == 'gpgsql'
  begin
    require 'pg' 
  rescue LoadError
    # The 'pg' gem needs some workarounds to work with the ruby runtime
    # provided by chef.  This recipe includes all needed workarounds.
    include_recipe 'postgresql::ruby'
  end
elsif launch == 'gsqlite3'
  [ 'libsqlite3-dev', 'sqlite3' ].each do |pkg|
    package pkg
  end
  gem_package 'sqlite3' do
    gem_binary chef_gem_binary
  end
end
