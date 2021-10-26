#
# Cookbook:: pdns
# Resources:: pdns_authoritative_service
#
# # Copyright:: 2021, DNSimple Corp.
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

provides :pdns_authoritative_service

include Pdns::AuthoritativeHelpers
property :instance_name, String, name_property: true, callbacks: {
  'should not contain a hyphen' => ->(param) { !param.include?('-') },
  'should not be blank' => ->(param) { !param.empty? },
}
property :virtual, [true, false], default: false
property :config_dir, String, default: lazy { default_authoritative_config_directory }

action :enable do
  service systemd_name(new_resource.instance_name, new_resource.virtual) do
    supports restart: true, status: true
    action :enable
  end
end

action :start do
  service systemd_name(new_resource.instance_name, new_resource.virtual) do
    supports restart: true, status: true
    action :start
  end
end

action :stop do
  service systemd_name(new_resource.instance_name, new_resource.virtual) do
    supports restart: true, status: true
    action :stop
  end
end

action :restart do
  service systemd_name(new_resource.instance_name, new_resource.virtual) do
    supports restart: true, status: true
    action :restart
  end
end

action :disable do
  service systemd_name(new_resource.instance_name, new_resource.virtual) do
    supports restart: true, status: true
    action :disable
  end
end
