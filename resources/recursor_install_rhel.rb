#
# Cookbook:: pdns
# Resources:: pdns_recursor_install
#
# Copyright:: 2017-2018 DNSimple Corp
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

provides :pdns_recursor_install, platform_family: 'rhel' do |node|
  node['platform_version'].to_i >= 6
end

property :version, String
property :series, String, default: '42'
property :debug, [true, false], default: false
property :allow_upgrade, [true, false], default: false

action :install do
  # We take advantage of the yum_repository call bellow that will reload yum sources
  # and will make epel repository available for the pdns-recursor dependency 'protobuf'
  yum_package 'epel-release' do
    action :install
    only_if { platform_family?('rhel') && node['platform_version'].to_f < 8.0 }
  end

  dnf_package 'epel-release' do
    action :install
    only_if { platform_family?('rhel') && node['platform_version'].to_f >= 8.0 }
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
  end

  yum_package 'pdns-recursor' do
    version new_resource.version
    action :upgrade if new_resource.allow_upgrade
    only_if { platform_family?('rhel') && node['platform_version'].to_f < 8.0 }
  end

  dnf_package 'pdns-recursor' do
    version new_resource.version
    action :upgrade if new_resource.allow_upgrade
    only_if { platform_family?('rhel') && node['platform_version'].to_f >= 8.0 }
  end
end

action :uninstall do
  yum_package 'pdns-recursor' do
    action :remove
    only_if { platform_family?('rhel') && node['platform_version'].to_f < 8.0 }
  end

  dnf_package 'pdns-recursor' do
    action :remove
    only_if { platform_family?('rhel') && node['platform_version'].to_f >= 8.0 }
  end
end
