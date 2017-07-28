#
# Cookbook Name:: pdns
# Resources:: pdns_recursor_service
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

provides :pdns_recursor_service, os: 'linux' do |node|
  %w(debian ubuntu centos).include?(node['platform'])
end

include Pdns::RecursorHelpers
property :instance_name, String, name_property: true
property :cookbook, [String, NilClass], default: 'pdns'
property :config_dir, String, default: lazy { default_recursor_config_directory }
property :source, [String, NilClass], default: lazy { "recursor.init.#{node['platform_family']}.erb" }
property :variables, Hash, default: {}

action :enable do
  template '/etc/init.d/pdns-recursor' do
    source new_resource.source
    owner 'root'
    group 'root'
    mode '0755'
    variables(variables: new_resource.variables)
    cookbook new_resource.cookbook
    action :create
  end

  link "/etc/init.d/#{sysvinit_name(new_resource.instance_name)}" do
    to 'pdns-recursor'
    not_if { new_resource.instance_name.empty? }
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
