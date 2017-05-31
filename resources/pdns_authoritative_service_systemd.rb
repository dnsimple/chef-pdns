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
include ::Pdns::PdnsAuthoritativeHelpers

resource_name :pdns_authoritative_service_systemd

# Inspired by
# https://github.com/chef/inspec/blob/master/lib/resources/service.rb#L104
provides :pdns_authoritative_service, os: 'linux' do |node|
  case node['platform']
  when 'ubuntu'
    node['platform_version'].to_f >= 15.04
  when 'debian'
    node['platform_version'].to_i > 7
  when 'redhat', 'centos', 'oracle'
    node['platform_version'].to_i >= 7
  when 'fedora'
    node['platform_version'].to_i >= 15
  end
end
# The following helper could also be used
# Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)

property :instance_name, String, name_property: true
property :config_dir, String, default: lazy { default_authoritative_config_directory }

action :enable do
  service 'pdns' do
    action [:stop, :disable]
  end

  service systemd_name(new_resource.instance_name) do
    supports restart: true, status: true
    action :enable
  end
end

action :start do
  service systemd_name(new_resource.instance_name) do
    supports restart: true, status: true
    action :start
  end
end

action :stop do
  service systemd_name(new_resource.instance_name) do
    supports restart: true, status: true
    action :stop
  end
end

action :restart do
  service systemd_name(new_resource.instance_name) do
    supports restart: true, status: true
    action :restart
  end
end

action_class.class_eval do
  def whyrun_supported?
    true
  end
end
