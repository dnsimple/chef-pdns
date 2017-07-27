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

resource_name :pdns_recursor_service_systemd

provides :pdns_recursor_service, os: 'linux' do |_node|
  Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
end

include Pdns::RecursorHelpers
property :instance_name, String, name_property: true
property :config_dir, String, default: lazy { default_recursor_config_directory }

action :enable do
  # To make sure the default package doesn't start any "pdns_recursor" daemon
  # because the default service could stop all other instances
  service 'pdns-recursor' do
    supports restart: true, status: true
    action [:disable, :stop]
    only_if { new_resource.instance_name.empty? }
  end

  service systemd_name(new_resource.instance_name) do
    supports restart: true, status: true
    action :enable
  end
end

action :start do
  service systemd_name(new_resource.instance_name) do
    supports restart: true, status: true
    action :start
  end
end

action :stop do
  service systemd_name(new_resource.instance_name) do
    supports restart: true, status: true
    action :stop
  end
end

action :restart do
  service systemd_name(new_resource.instance_name) do
    supports restart: true, status: true
    action :restart
  end
end
