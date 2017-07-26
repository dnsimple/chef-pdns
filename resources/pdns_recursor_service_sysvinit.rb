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
include ::Pdns::PdnsRecursorHelpers

resource_name :pdns_recursor_service_sysvinit

provides :pdns_recursor_service, os: 'linux' do |node|
  %w(debian ubuntu centos).include?(node['platform'])
end

property :instance_name, String, name_property: true
property :cookbook, [String, NilClass], default: 'pdns'
property :config_dir, String, default: lazy { default_recursor_config_directory }
property :source, [String, NilClass], default: lazy { "recursor.init.#{node['platform_family']}.erb" }
property :socket_dir, String, default: lazy { |resource| "/var/run/#{resource.instance_name}" }

action :enable do
   # Some distros start pdns-recursor after installing it, we want to stop it
   # The behavior of the init script on CentOS 6 causes a bug so we skip it there
   # (see https://github.com/dnsimple/chef-pdns/issues/77#issuecomment-311644973)
   # We want to prevent the default recursor to start on boot
   pdns_recursor_actions = [:disable]
   pdns_recursor_actions = pdns_recursor_actions.unshift(:stop) if node['platform_family'] == 'debian'

   service 'pdns-recursor' do
     supports restart: true, status: true
     action pdns_recursor_actions
     only_if { new_resource.instance_name.empty? }
   end

  template '/etc/init.d/pdns-recursor' do
    source new_resource.source
    owner 'root'
    group 'root'
    mode '0755'
    variables()
    cookbook new_resource.cookbook
    action :create
  end

  sysvinit_script = ::File.join('/etc/init.d', sysvinit_name(new_resource.instance_name))
  link sysvinit_script do
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

action_class.class_eval do
  def whyrun_supported?
    true
  end
end
