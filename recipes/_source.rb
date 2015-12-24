#
# Cookbook Name:: pdns
# Recipe:: _source
#
# Copyright 2014, Aetrion, LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

flavor = node['pdns']['flavor']
version = node['pdns']['source']['version']

include_recipe 'build-essential'

package 'libtool'
package 'pkg-config'
package 'libboost-all-dev'
package 'ragel'

# Base install directory
pdns_basepath = node['pdns']['source']['path']
# Filename
pdns_filename = pdns_file(node['pdns']['source']['url'])
# Base install dir + Filename
pdns_filepath = "#{pdns_basepath}/#{pdns_filename}"
# Base install dir + (Filename - Extension)
pdns_dir = pdns_dir(pdns_filename)

remote_file pdns_filepath do
  source lazy { node['pdns']['source']['url'] }
  action :create_if_missing
end

user node['pdns']['user'] do
  system true
  shell  '/bin/false'
end

bash 'unarchive_source' do
  cwd node['pdns']['source']['path']
  code <<-EOH
  tar xjf #{::File.basename(pdns_filepath)} -C #{::File.dirname(pdns_filepath)}
  EOH
  not_if { ::File.directory?("#{pdns_dir}") }
end

directory node['pdns'][flavor]['config']['config_dir'] do
  owner node['pdns']['user']
  group node['pdns']['group']
  mode '0755'
end

modules = String.new
binary_string = 'pdns_recursor'

if [ 'slave', 'authoritative' ].include? flavor
  modules = "--with-modules='#{node['pdns']['source']['backends'].join(' ')}' "
  binary_string = 'pdns_server'

  execute 'pdns: bootstrap' do
    # This insanity is documented in the README
    command './bootstrap && ./bootstrap'
    cwd pdns_dir
    not_if "/usr/local/sbin/#{binary_string} --version 2>&1 | grep #{version}"
  end

  pdns_source_module_requirements.each do |pkg|
    package pkg
  end
end

execute 'pdns: configure' do
  command './configure ' +
  modules +
  "--sysconfdir=#{node['pdns'][flavor]['config']['config_dir']} " +
  '--without-lua'
  cwd pdns_dir
  not_if "/usr/local/sbin/#{binary_string} --version 2>&1 | grep #{version}"
end

execute 'pdns: build' do
  command 'make'
  cwd pdns_dir
  not_if "/usr/local/sbin/#{binary_string} --version 2>&1 | grep #{version}"
end

execute 'pdns: install' do
  command 'make install'
  cwd pdns_dir
  not_if "/usr/sbin/#{binary_string} --version 2>&1 | grep #{version}"
end
