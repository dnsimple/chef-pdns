#
# Cookbook:: pdns
# Resources:: pdns_recursor_install
#
# # Copyright:: 2023, DNSimple Corp.
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

provides :pdns_recursor_install, platform: 'ubuntu'
unified_mode true do |node|
  node['platform_version'].to_f >= 20.04
end

provides :pdns_recursor_install, platform: 'debian' do |node|
  node['platform_version'].to_i >= 9
end

property :series, String, default: '52'
property :version, String
property :debug, [true, false], default: false
property :allow_upgrade, [true, false], default: false

action :install do
  apt_repository 'powerdns-recursor' do
    uri "http://repo.powerdns.com/#{node['platform']}"
    distribution "#{node['lsb']['codename']}-rec-#{new_resource.series}"
    components ['main']
    key 'powerdns.asc'
    cookbook 'pdns'
  end

  apt_preference 'pdns-*' do
    pin          'origin repo.powerdns.com'
    pin_priority '600'
  end

  apt_package 'pdns-recursor' do
    action :upgrade if new_resource.allow_upgrade
    version new_resource.version
  end

  apt_package 'pdns-recursor-dbgsym' do
    action :upgrade if new_resource.allow_upgrade
    only_if { new_resource.debug }
  end
end

action :uninstall do
  apt_package 'pdns-recursor' do
    action :remove
  end

  apt_package 'pdns-recursor-dbgsym' do
    action :remove
  end
end
