#
# Cookbook:: pdns
# Resources:: pdns_authoritative_config
#
# # Copyright:: 2025, DNSimple Corp.
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

provides :pdns_authoritative_config, platform: 'ubuntu'
unified_mode true do |node|
  node['platform_version'].to_f >= 20.04
end

provides :pdns_authoritative_config, platform: 'debian' do |node|
  node['platform_version'].to_i >= 9
end

provides :pdns_authoritative_config, platform_family: 'rhel' do |node|
  node['platform_version'].to_i >= 7
end

include Pdns::AuthoritativeHelpers
property :instance_name, String, name_property: true, callbacks: {
  'should not contain a hyphen' => ->(param) { !param.include?('-') },
  'should not be blank' => ->(param) { !param.empty? },
}
property :virtual, [true, false], default: false
property :launch, Array, default: ['bind']
property :config_dir, String, default: lazy { default_authoritative_config_directory }
property :socket_dir, String, default: '/var/run/pdns'

property :source, String, default: 'authoritative.conf.erb'
property :cookbook, String, default: 'pdns'
property :variables, Hash, default: lazy { |resource| { bind_config: "#{resource.config_dir}/bindbackend.conf" } }

action :create do
  user 'pdns authoritative' do
    username lazy { default_authoritative_run_user }
    home lazy { default_user_attributes[:home] }
    shell lazy { default_user_attributes[:shell] }
    system true
    action :create
  end

  group 'pdns authoritative' do
    group_name lazy { default_authoritative_run_user }
    members lazy { [ default_authoritative_run_user ] }
    system true
    append true
    action :create
  end

  directory new_resource.config_dir do
    owner 'root'
    group lazy { default_authoritative_run_user }
    mode '0755'
    action :create
  end

  template "#{new_resource.config_dir}/#{authoritative_instance_config(new_resource.instance_name, new_resource.virtual)}" do
    source new_resource.source
    cookbook new_resource.cookbook
    owner 'root'
    group lazy { default_authoritative_run_user }
    mode '0640'
    variables(
      launch: new_resource.launch,
      socket_dir: new_resource.socket_dir,
      variables: new_resource.variables
    )
  end
end
