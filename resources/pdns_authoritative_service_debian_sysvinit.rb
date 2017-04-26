#
# Cookbook Name:: pdns
# Resources:: pdns_authoritative_service
#
# Copyright 2017, Aetrion, LLC DBA DNSimple
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

resource_name :pdns_authoritative_service_debian_sysvinit

provides :pdns_authoritative_service_sysvinit

provides :pdns_authoritative_service, platform: 'ubuntu' do |node|
  node['platform_version'].to_f == 14.04
end

provides :pdns_authoritative_service, platform: 'debian' do |node|
  node['platform_version'].to_i >= 8
end

property :instance_name, String, name_property: true
property :cookbook, [String,nil], default: 'pdns'
property :source, [String,nil], default: 'authoritative.init.debian.erb'
property :config_dir, String, default: lazy { default_authoritative_config_directory }
property :socket_dir, String, default: lazy { |resource| "/var/run/#{resource.instance_name}" }

action :enable do
  service 'pdns' do
    provider Chef::Provider::Service::Init::Debian
    action [:stop, :disable]
  end

  template "/etc/init.d/pdns-authoritative-#{new_resource.instance_name}" do
    source new_resource.source
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      socket_dir: new_resource.socket_dir
      )
    cookbook new_resource.cookbook
    action :create
  end

  service "pdns-authoritative-#{new_resource.instance_name}" do
    provider Chef::Provider::Service::Init::Debian
    pattern 'pdns_server'
    supports restart: true, status: true
    action :enable
  end
end

action :start do
  service "pdns-authoritative-#{new_resource.instance_name}" do
    provider Chef::Provider::Service::Init::Debian
    pattern 'pdns_server'
    supports restart: true, status: true
    action :start
  end
end

action :stop do
  service "pdns-authoritative-#{new_resource.instance_name}" do
    provider Chef::Provider::Service::Init::Debian
    pattern 'pdns_server'
    supports restart: true, status: true
    action :stop
  end
end

action :restart do
  service "pdns-authoritative-#{new_resource.instance_name}" do
    provider Chef::Provider::Service::Init::Debian
    pattern 'pdns_server'
    supports restart: true, status: true
    action :restart
  end
end
