#
# Cookbook Name:: pdns
# Resources:: pdns_authoritative_postgres
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

resource_name :pdns_authoritative_backend

provides :pdns_authoritative_backend, platform: 'ubuntu' do |node| #~FC005
  node['platform_version'].to_f == 14.04
end

provides :pdns_authoritative_backend, platform: 'debian' do |node| #~FC005
  node['platform_version'].to_i >= 8
end

provides :pdns_authoritative_install, platform: 'centos' do |node| #~FC005
  node['platform_version'].to_i >= 6
end

property :instance_name, String, name_property: true
property :version, [String, nil], default: nil

action :install do
  package backend_package_per_platform do
    action :install
  end
end

action :uninstall do
  apt_package backend_package_per_platform do
    action :remove
    version new_resource.version
  end
end
