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

resource_name :pdns_recursor_install_rhel

provides :pdns_recursor_install, platform: 'centos' do |node|
  node['platform_version'].to_i >= 6
end

property :instance_name, String, name_property: true
property :version, [String, nil], default: nil
property :debug, [true, false], default: false
property :baseurl, String, default: 'http://repo.powerdns.com/centos/$basearch/$releasever/rec-40'
property :gpgkey, String, default: 'https://repo.powerdns.com/FD380FBB-pub.asc'
property :baseurl_debug, [String, nil], default: 'http://repo.powerdns.com/centos/$basearch/$releasever/rec-40/debug'

action :install do

  # We take advantage of the yum_repository call bellow that will reload yum sources
  # and will make epel repository available for the pdns-recursor dependency 'protobuf'

  yum_package 'epel-release' do
    action :install
    only_if { node['platform_version'].to_i == 6 }
  end

  repository_version = new_resource.baseurl.split('/').last

  yum_repository "powerdns-#{repository_version}" do
    description "PowerDNS repository for PowerDNS Recursor - #{repository_version}"
    baseurl new_resource.baseurl
    gpgkey new_resource.gpgkey
    priority '90'
    includepkgs 'pdns*'
    action :create
  end

  yum_repository "powerdns-#{repository_version}-debuginfo" do
    description "PowerDNS repository for PowerDNS Recursor - #{repository_version} debug symbols"
    baseurl new_resource.baseurl_debug
    gpgkey new_resource.gpgkey
    priority '90'
    includepkgs 'pdns*'
    action :create
    not_if { new_resource.debug }
  end

  yum_package 'pdns-recursor' do
    version new_resource.version
  end
end

action :uninstall do
  yum_package 'pdns-recursor' do
    action :remove
  end
end
