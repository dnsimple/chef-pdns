#
# Cookbook Name:: pdns
# Resources:: pdns_authoritative_service
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
include ::Pdns::PdnsAuthoritativeHelpers

resource_name :pdns_authoritative_service_sysvinit

provides :pdns_authoritative_service, os: 'linux' do |node|
  %w(ubuntu debian centos).include?(node['platform'])
end

property :instance_name, String, name_property: true
property :cookbook, %w(String NilClass)
property :source, %w(String NilClass)
property :config_dir, String, default: lazy { default_authoritative_config_directory }
property :variables, String

action :enable do
  service 'pdns' do
    action [:stop, :disable]
  end

  sysvinit_script = ::File.join('/etc/init.d', sysvinit_name(new_resource.instance_name))
  if new_resource.source
    template sysvinit_script do
      source new_resource.source
      owner 'root'
      group 'root'
      mode '0755'
      variables(
        variables: new_resource.variables
      )
      cookbook new_resource.cookbook unless new_resource.cookbook.nil?
      action :create
    end
  else
    # Has specified in the PowerDNS documentation, a symlink to the init.d script
    # "pdns" should be enough for setting up a Virtual instance:
    # https://github.com/PowerDNS/pdns/blob/master/docs/markdown/authoritative/running.md#starting-virtual-instances-with-sysv-init-scripts
    link sysvinit_script do
      to 'pdns'
    end
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
