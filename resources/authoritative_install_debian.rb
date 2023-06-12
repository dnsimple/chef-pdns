#
# Cookbook:: pdns
# Resources:: pdns_authoritative_install_debian
#
# # Copyright:: 2021, DNSimple Corp.
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

provides :pdns_authoritative_install, platform: 'ubuntu'
unified_mode true do |node|
  node['platform_version'].to_f >= 20.04
end

provides :pdns_authoritative_install, platform: 'debian' do |node|
  node['platform_version'].to_i >= 9
end

property :version, String
property :series, String, default: '47'
property :debug, [true, false], default: false
property :allow_upgrade, [true, false], default: false
property :backends, Array

action :install do
  apt_repository 'powerdns-authoritative' do
    uri "http://repo.powerdns.com/#{node['platform']}"
    distribution "#{node['lsb']['codename']}-auth-#{new_resource.series}"
    arch 'amd64'
    components ['main']
    key 'powerdns.asc'
    cookbook 'pdns'
  end

  apt_preference 'pdns-*' do
    pin          'origin repo.powerdns.com'
    pin_priority '600'
  end

  if new_resource.backends
    new_resource.backends.each do |backend|
      apt_package "pdns-backend-#{backend}" do
        action :upgrade if new_resource.allow_upgrade
        version new_resource.version
      end
    end
  end

  apt_package 'pdns-server' do
    action :upgrade if new_resource.allow_upgrade
    version new_resource.version
  end

  apt_package 'pdns-server-dbgsym' do
    action :upgrade if new_resource.allow_upgrade
    only_if { new_resource.debug }
  end
end

action :uninstall do
  apt_package 'pdns-server' do
    action :remove
    version new_resource.version
  end

  apt_package 'pdns-server-dbgsym' do
    action :remove
  end
end
