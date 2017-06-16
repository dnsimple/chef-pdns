#
# Cookbook Name:: pdns
# Resources:: pdns_recursor_install
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

provides :pdns_recursor_install, os: 'linux'

property :instance_name, String, name_property: true
property :version, [String, nil], default: nil
property :uri, String, default: lazy { "http://repo.powerdns.com/#{node['platform']}" }
property :distribution, String, default: lazy { "#{node['lsb']['codename']}-rec-40" }
property :key, String, default: 'https://repo.powerdns.com/FD380FBB-pub.asc'
property :baseurl, String, default: ::Pdns::Helpers::REDHAT_URL['rec']['baseurl']
property :gpgkey, String, default: ::Pdns::Helpers::REDHAT_URL['rec']['gpgkey']
property :baseurl_debug, String, default: ::Pdns::Helpers::REDHAT_URL['rec']['baseurl_debug']
property :debug, [TrueClass, FalseClass], default: false

action :install do
  package 'epel-release' do
    action :install
    only_if { node['platform_family'] == 'rhel' && node['platform_version'].to_i == 6 }
  end

  # Automatic repository selection
  copy_properties_to(pdns_recursor_repo(new_resource.instance_name))

  package 'pdns-recursor' do
    action :install
    version new_resource.version if new_resource.version
  end

  package 'pdns-recursor-debuginfo' do
    action :install
    version new_resource.version if new_resource.version
    only_if { new_resource.debug && node['platform_family'] == 'rhel' }
  end
end

action :uninstall do
  package 'pdns-recursor' do
    action :remove
  end

  package 'pdns-recursor-debuginfo' do
    action :remove
    only_if { node['platform_family'] == 'rhel' }
  end

  copy_properties_to(pdns_recursor_repo(new_resource.instance_name) { action :delete })
end

action_class.class_eval do
  def whyrun_supported?
    true
  end
end
