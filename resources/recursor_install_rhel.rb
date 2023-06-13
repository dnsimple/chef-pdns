#
# Cookbook:: pdns
# Resources:: pdns_recursor_install
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

provides :pdns_recursor_install, platform_family: 'rhel'
unified_mode true do |node|
  node['platform_version'].to_i >= 7
end

property :version, String
property :series, String, default: '48'
property :debug, [true, false], default: false
property :allow_upgrade, [true, false], default: false

action :install do
  # We take advantage of the yum_repository call bellow that will reload yum sources
  # and will make epel repository available for the pdns-recursor dependency 'protobuf'
  package 'epel-release' do
    action :install
  end

  yum_repository 'powerdns-recursor' do
    description 'PowerDNS repository for PowerDNS Recursor'
    baseurl "http://repo.powerdns.com/centos/$basearch/$releasever/rec-#{new_resource.series}"
    gpgkey 'https://repo.powerdns.com/FD380FBB-pub.asc'
    priority '90'
    includepkgs 'pdns*'
    action :create
  end

  yum_repository 'powerdns-recursor-debug' do
    description 'PowerDNS repository for PowerDNS Recursor with Debug Symbols'
    baseurl "http://repo.powerdns.com/centos/$basearch/$releasever/rec-#{new_resource.series}/debug"
    gpgkey 'https://repo.powerdns.com/FD380FBB-pub.asc'
    priority '90'
    includepkgs 'pdns*'
    action :create
    only_if { new_resource.debug }
  end

  package 'pdns-recursor' do
    version new_resource.version
    action :upgrade if new_resource.allow_upgrade
  end

  package 'pdns-recursor-debuginfo' do
    version new_resource.version
    action :upgrade if new_resource.allow_upgrade
    only_if { new_resource.debug }
  end
end

action :uninstall do
  package 'pdns-recursor' do
    action :remove
  end

  package 'pdns-recursor-debuginfo' do
    action :remove
  end
end
