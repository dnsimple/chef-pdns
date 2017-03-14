#
# Cookbook Name:: pdns
# Resources:: recursor_install
#
# Copyright 2016, Aetrion, LLC DBA DNSimple
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

resource_name :pdns_recursor_service_rhel

provides :pdns_recursor_service, platform: 'centos' do |node|
  node['platform_version'].to_i >= 6
end

property :instance_name, String, name_property: true
property :cookbook, [String,nil], default: 'pdns'
property :source, [String,nil], default: 'recursor.init.debian.erb'
property :config_dir, String, default: lazy { default_config_directory }
property :socket_dir, String, default: lazy { |resource| "/var/run/#{resource.instance_name}" }
property :instances_dir, String, default: 'recursor.d'

action :enable do
  recursor_instance_dir = "#{new_resource.config_dir}/#{new_resource.instances_dir}/#{new_resource.instance_name}"

  template "/etc/init.d/#{new_resource.instance_name}" do
    source new_resource.source
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      instance_name: new_resource.instance_name,
      instance_dir: recursor_instance_dir,
      socket_dir: new_resource.socket_dir
      )
    cookbook new_resource.cookbook
    action :create
  end

  service "pdns-recursor-#{new_resource.instance_name}" do
    service_name 'pdns-recursor'
    pattern 'pdns_recursor'
    supports restart: true, status: true
    action :enable
  end
end

action :start do
  service "pdns-recursor-#{new_resource.instance_name}" do
    service_name 'pdns-recursor'
    pattern 'pdns_recursor'
    supports restart: true, status: true
    action :start
  end
end

action :stop do
  service "pdns-recursor-#{new_resource.instance_name}" do
    service_name 'pdns-recursor'
    pattern 'pdns_recursor'
    supports restart: true, status: true
    action :stop
  end
end

action :restart do
  service "pdns-recursor-#{new_resource.instance_name}" do
    service_name 'pdns-recursor'
    pattern 'pdns_recursor'
    supports restart: true, status: true
    action :restart
  end
end