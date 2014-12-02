#
# Cookbook Name:: pdns
# Recipe:: sqlite3
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'sqlite'
include_recipe 'build-essential'

package 'sqlite-devel' do
  package_name platform_family?('rhel') ? 'sqlite-devel' : 'libsqlite3-dev'
end

gem_package 'sqlite3'

package 'pdns-backend-sqlite3' do
  package_name value_for_platform(
    'arch' => { 'default' => 'pdns' },
    %w(debian ubuntu) => { 'default' => 'pdns-backend-sqlite3' },
    %w(redhat centos fedora) => { 'default' => 'pdns-backend-sqlite' },
    'default' => 'pdns-backend-sqlite3'
  )
end

directory node['pdns']['backend_dir']

cookbook_file '/var/tmp/pdns_schema.sql' do
  source 'schema.sql'
end

ruby_block 'load pdns schema' do
  block do
    require 'sqlite3'
    SQLite3::Database.new(::File.join(node['pdns']['backend_dir'], 'pdns.sqlite')) do |db|
      db.execute_batch(IO.read('/var/tmp/pdns_schema.sql'))
    end
  end
  not_if do
    require 'sqlite3'
    db = SQLite3::Database.new(::File.join(node['pdns']['backend_dir'], 'pdns.sqlite'))
    db.execute("SELECT * FROM sqlite_master WHERE type='table';").count != 0
  end
end

template ::File.join(node['pdns']['server']['config_dir'], 'conf.d', 'backend.conf') do
  source 'sqlite-backend.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(:backend_dir => node['pdns']['backend_dir'])
  notifies :restart, 'service[pdns]'
end
