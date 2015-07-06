#
# Cookbook Name:: pdns
# Recipe:: recursor_source
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

include_recipe 'build-essential'

package 'libtool'
package 'pkg-config'
package 'libboost-all-dev'
package 'ragel'

# Base install directory
pdns_basepath = node['pdns']['source']['path']
# Filename
pdns_filename = pdns_file(node['pdns']['recursor']['source']['url'])
# Base install dir + Filename
pdns_filepath = "#{pdns_basepath}/#{pdns_filename}"
# Base install dir + (Filename - Extension)
pdns_dir = pdns_dir(pdns_filename)

remote_file pdns_filepath do
  source node['pdns']['recursor']['source']['url']
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

directory node['pdns']['recursor']['config_dir'] do
  owner node['pdns']['user']
  group node['pdns']['group']
  mode '0755'
end

version = node['pdns']['recursor']['source']['version']

execute 'pdns: configure' do
  command './configure ' +
    "--sysconfdir=#{node['pdns']['recursor']['config_dir']} " +
    '--without-lua'
  cwd pdns_dir
  creates "#{pdns_dir}/dep"
end

execute 'pdns: build' do
  command 'make'
  cwd pdns_dir
  creates "#{pdns_dir}/pdns/pdns_recursor"
end

execute 'pdns: install' do
  command 'make install'
  cwd pdns_dir
  not_if "/usr/sbin/pdns_recursor --version 2>&1 | grep #{version}"
end

template "#{node['pdns']['recursor']['config_dir']}/recursor.conf" do
  source 'recursor.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[pdns-recursor]'
end

service 'pdns-recursor' do
  provider Chef::Provider::Service::Init::Debian
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end
