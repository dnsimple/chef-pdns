#
# Cookbook:: pdns
# Resources:: pdns_authoritative_install_rhel
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

provides :pdns_authoritative_install, platform_family: 'rhel'
unified_mode true do |node|
  node['platform_version'].to_i >= 7
end

property :version, String
property :series, String, default: '45'
property :debug, [true, false], default: false
property :allow_upgrade, [true, false], default: false
property :backends, Array

action :install do
  package 'epel-release' do
    action :install
  end

  yum_repository 'powerdns-authoritative' do
    description 'PowerDNS repository for PowerDNS Authoritative'
    baseurl "http://repo.powerdns.com/centos/$basearch/$releasever/auth-#{new_resource.series}"
    gpgkey 'https://repo.powerdns.com/FD380FBB-pub.asc'
    priority '90'
    includepkgs 'pdns*'
    action :create
  end

  yum_repository 'powerdns-authoritative-debuginfo' do
    description 'PowerDNS repository for PowerDNS Authoritative'
    baseurl "http://repo.powerdns.com/centos/$basearch/$releasever/auth-#{new_resource.series}/debug"
    gpgkey 'https://repo.powerdns.com/FD380FBB-pub.asc'
    priority '90'
    includepkgs 'pdns*'
    action :create
    only_if { new_resource.debug }
  end

  if new_resource.backends
    new_resource.backends.each do |backend|
      package "pdns-backend-#{backend}" do
        action :upgrade if new_resource.allow_upgrade
        version new_resource.version
      end
    end
  end

  package 'pdns' do
    version new_resource.version
    action :upgrade if new_resource.allow_upgrade
  end

  package 'pdns-debuginfo' do
    version new_resource.version
    action :upgrade if new_resource.allow_upgrade
    only_if { new_resource.debug }
  end
end

action :uninstall do
  package 'pdns' do
    action :remove
    version new_resource.version
  end

  package 'pdns-debuginfo' do
    action :remove
    version new_resource.version
  end
end
