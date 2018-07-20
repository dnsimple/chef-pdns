#
# Cookbook Name:: pdns
# Resources:: pdns_authoritative_config
#
# Copyright 2016-2018 DNSimple Corp
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

provides :pdns_authoritative_config, platform: 'ubuntu' do |node| # ~FC005
  node['platform_version'].to_f >= 14.04
end

provides :pdns_authoritative_config, platform: 'debian' do |node| # ~FC005
  node['platform_version'].to_i >= 8
end

provides :pdns_authoritative_config, platform_family: 'rhel' do |node| # ~FC005
  node['platform_version'].to_i >= 6
end

include Pdns::AuthoritativeHelpers
property :instance_name, String, name_property: true, callbacks: {
  'should not contain a hyphen' => ->(param) { !param.include?('-') },
}
property :launch, Array, default: ['bind']
property :config_dir, String, default: lazy { default_authoritative_config_directory }
property :run_group, String, default: lazy { default_authoritative_run_user }
property :run_user, String, default: lazy { default_authoritative_run_user }
property :run_user_home, String, default: lazy { default_user_attributes[:home] }
property :run_user_shell, String, default: lazy { default_user_attributes[:shell] }
property :socket_dir, String, default: lazy { |resource| "/var/run/#{resource.instance_name}" }
property :setuid, String, default:  lazy { |resource| resource.run_user }
property :setgid, String, default:  lazy { |resource| resource.run_group }

property :source, String, default: 'authoritative_service.conf.erb'
property :cookbook, String, default: 'pdns'
property :variables, Hash, default: lazy { |resource| { bind_config: "#{resource.config_dir}/bindbackend.conf" } }

action :create do
  user new_resource.run_user do
    home new_resource.run_user_home
    shell new_resource.run_user_shell
    system true
    action :create
  end

  group new_resource.run_group do
    members [new_resource.run_user]
    system true
    append true
    action :create
  end

  directory new_resource.socket_dir do
    owner new_resource.run_user
    group new_resource.run_group
    # Because of the DynListener creation before dropping privileges, the
    # socket-directory has to be '0777' for now
    # Issue: https://github.com/PowerDNS/pdns/issues/4826
    mode Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd) ? '0777' : '0755'
    recursive true
    action :create
  end

  directory new_resource.config_dir do
    owner 'root'
    group new_resource.run_group
    mode '0755'
    action :create
  end

  template "#{new_resource.config_dir}/#{authoritative_instance_config(new_resource.instance_name)}" do
    source new_resource.source
    cookbook new_resource.cookbook
    owner 'root'
    group new_resource.run_group
    mode '0640'
    variables(
      launch: new_resource.launch,
      socket_dir: new_resource.socket_dir,
      setuid: new_resource.setuid,
      setgid: new_resource.setgid,
      variables: new_resource.variables
    )
  end
end
