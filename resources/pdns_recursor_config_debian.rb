#
# Cookbook Name:: pdns
# Resources:: recursor_config_debian
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

resource_name :pdns_recursor_config_debian

provides :pdns_recursor_config, platform: 'ubuntu' do |node|
  node['platform_version'].to_f >= 14.04
end

provides :pdns_recursor_config, platform: 'debian' do |node|
  node['platform_version'].to_i >= 8
end

property :instance_name, String, name_property: true
property :config_dir, String, default: '/etc/powerdns'
property :run_group, String, default: lazy { default_run_user }
property :run_user, String, default: lazy { default_run_user }
property :run_user_home, String, default: lazy { default_user_attributes[:home] }
property :run_user_shell, String, default: lazy { default_user_attributes[:shell] }
property :setuid, String, default: lazy { |resource| resource.run_user }
property :setgid, String, default: lazy { |resource| resource.run_group }

property :source, [String,nil], default: nil
property :cookbook, [String,nil], default: nil
property :variables, [Hash], default: {}

action :create do
  directory new_resource.config_dir do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  user new_resource.run_user do
    home new_resource.run_user_home
    shell new_resource.run_user_shell
    system true
    action :create
  end

  group new_resource.run_group do
    members [new_resource.run_user]
    system true
    action :create
  end

  template "#{new_resource.config_dir}/#{new_resource.instance_name}-recursor.conf" do
    source new_resource.source
    owner 'root'
    group 'root'
    mode 0640
    notifies :restart, 'service[pdns-recursor]'
    variables(
      config_dir: new_resource.config_dir,
      setuid: new_resource.setuid,
      setgid: new_resource.setgid,
      variables: new_resource.variables
      )
  end
end
