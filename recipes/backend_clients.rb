#
# Cookbook Name:: pdns
# Recipe:: backend_clients
#

include_recipe 'apt'
include_recipe 'build-essential'
launch = node['pdns']['authoritative']['config']['launch']

chef_gem 'sequel' do
  compile_time false if respond_to?(:compile_time)
end

if launch == 'gmysql'  
  chef_gem 'mysql2' do
    compile_time false
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
  chef_gem 'sqlite3' do
    compile_time false
  end
end
