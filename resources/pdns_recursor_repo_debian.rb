#
# Cookbook Name:: pdns
# Resources:: pdns_recursor_
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
include ::Pdns::Helpers

resource_name :pdns_recursor_repo_debian

provides :pdns_recursor_repo, os: 'linux' do |_node|
  Chef::Platform::ServiceHelpers.service_resource_providers.include?(:debian)
end

property :uri, String, default: lazy { "http://repo.powerdns.com/#{node['platform']}" }
property :distribution, String, default: lazy { "#{node['lsb']['codename']}-rec-40" }
property :key, String, default: 'https://repo.powerdns.com/FD380FBB-pub.asc'

action :create do
  apt_repository repository_name(new_resource.baseurl, new_resource.instance_name) do
    uri new_resource.uri
    distribution new_resource.distribution
    arch node['kernel']['machine'] == 'x86_64' ? 'amd64' : 'i386'
    components ['main']
    key new_resource.key
    action :add
  end

  apt_preference 'pdns-*' do
    pin "origin #{URI(new_resource.uri).host}"
    pin_priority '600'
  end
end

action :delete do
  apt_repository repository_name(new_resource.baseurl, new_resource.instance_name) do
    uri new_resource.uri
    distribution new_resource.distribution
    arch node['kernel']['machine'] == 'x86_64' ? 'amd64' : 'i386'
    components ['main']
    key new_resource.key
    action :remove
  end

  apt_preference 'pdns-*' do
    action :remove
  end
end

action_class.class_eval do
  def whyrun_supported?
    true
  end
end
