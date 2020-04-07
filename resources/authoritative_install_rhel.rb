#
# Cookbook:: pdns
# Resources:: pdns_authoritative_install_rhel
#
# Copyright:: 2016-2018 DNSimple Corp
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

provides :pdns_authoritative_install, platform_family: 'rhel' do |node|
  node['platform_version'].to_i >= 6
end

property :version, String
property :series, String, default: '42'
property :debug, [true, false], default: false
property :allow_upgrade, [true, false], default: false
property :backends, Array

action :install do
  yum_package 'epel-release' do
    action :install
    only_if { platform_family?('rhel') && node['platform_version'].to_f < 8.0 }
  end

  dnf_package 'epel-release' do
    action :install
    only_if { platform_family?('rhel') && node['platform_version'].to_f >= 8.0 }
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
    not_if { new_resource.debug }
  end

  if new_resource.backends
    new_resource.backends.each do |backend|
      yum_package "pdns-backend-#{backend}" do
        action :upgrade if new_resource.allow_upgrade
        version new_resource.version
        only_if { platform_family?('rhel') && node['platform_version'].to_f < 8.0 }
      end

      dnf_package "pdns-backend-#{backend}" do
        action :upgrade if new_resource.allow_upgrade
        version new_resource.version
        only_if { platform_family?('rhel') && node['platform_version'].to_f >= 8.0 }
      end
    end
  end

  yum_package 'pdns' do
    version new_resource.version
    action :upgrade if new_resource.allow_upgrade
    only_if { platform_family?('rhel') && node['platform_version'].to_f < 8.0 }
  end

  dnf_package 'pdns' do
    version new_resource.version
    action :upgrade if new_resource.allow_upgrade
    only_if { platform_family?('rhel') && node['platform_version'].to_f >= 8.0 }
  end
end

action :uninstall do
  yum_package 'pdns' do
    action :remove
    version new_resource.version
    only_if { platform_family?('rhel') && node['platform_version'].to_f < 8.0 }
  end

  dnf_package 'pdns' do
    action :remove
    version new_resource.version
    only_if { platform_family?('rhel') && node['platform_version'].to_f >= 8.0 }
  end
end
