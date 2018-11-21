#
# Cookbook Name:: pdns
# Resources:: pdns_authoritative_service
#
# Copyright 2017-2018 DNSimple Corp
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

provides :pdns_authoritative_service, os: 'linux' do |node|
  %w(ubuntu debian centos).include?(node['platform'])
end

include Pdns::AuthoritativeHelpers
property :instance_name, String, name_property: true, callbacks: {
  'should not contain a hyphen' => ->(param) { !param.include?('-') },
  'should not be blank' => ->(param) { !param.empty? },
}
property :virtual, [true, false], default: false
property :cookbook, String, default: 'pdns'
property :source, String
property :config_dir, String, default: lazy { default_authoritative_config_directory }
property :variables, Hash, default: {}

action :enable do
  template "/etc/init.d/#{sysvinit_name}" do
    source new_resource.source
    owner 'root'
    group 'root'
    mode '0755'
    variables(new_resource.variables)
    action :create
    only_if { new_resource.property_is_set?(:source) }
  end

  # Create a symlink to the original pdns script to make a virtual instance
  # https://doc.powerdns.com/md/authoritative/running/#virtual-hosting
  link "/etc/init.d/#{sysvinit_name(new_resource.instance_name)}" do
    to '/etc/init.d/pdns'
    not_if { new_resource.instance_name.empty? || new_resource.property_is_set?(:source) }
  end

  service sysvinit_name(new_resource.instance_name) do
    supports restart: true, status: true
    action :enable
  end
end

action :start do
  service sysvinit_name(new_resource.instance_name) do
    supports restart: true, status: true
    action :start
  end
end

action :stop do
  service sysvinit_name(new_resource.instance_name) do
    supports restart: true, status: true
    action :stop
  end
end

action :restart do
  service sysvinit_name(new_resource.instance_name) do
    supports restart: true, status: true
    action :restart
  end
end
