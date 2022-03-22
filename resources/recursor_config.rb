#
# Cookbook:: pdns
# Resources:: pdns_recursor_config
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

provides :pdns_recursor_config, platform: 'ubuntu'
unified_mode true do |node|
  node['platform_version'].to_f >= 18.04
end

provides :pdns_recursor_config, platform: 'debian' do |node|
  node['platform_version'].to_i >= 9
end

provides :pdns_recursor_config, platform_family: 'rhel' do |node|
  node['platform_version'].to_i >= 7
end

include Pdns::RecursorHelpers
property :instance_name, String, name_property: true, callbacks: {
  'should not contain a hyphen' => ->(param) { !param.include?('-') },
  'should not be blank' => ->(param) { !param.empty? },
}
property :virtual, [true, false], default: false
property :config_dir, String, default: lazy { default_recursor_config_directory }
property :socket_dir, String, default: '/var/run/pdns-recursor'

property :source, String, default: 'recursor.conf.erb'
property :cookbook, String, default: 'pdns'
property :variables, Hash, default: {}

action :create do
  user 'pdns recursor' do
    username lazy { default_recursor_run_user }
    home lazy { default_user_attributes[:home] }
    shell lazy { default_user_attributes[:shell] }
    system true
    action :create
  end

  group 'pdns recursor' do
    group_name lazy { default_recursor_run_user }
    members lazy { [ default_recursor_run_user ] }
    system true
    append true
    action :create
  end

  directory new_resource.config_dir do
    owner 'root'
    group lazy { default_recursor_run_user }
    mode '0755'
    action :create
  end

  template "#{new_resource.config_dir}/#{recursor_instance_config(new_resource.instance_name, new_resource.virtual)}" do
    source new_resource.source
    cookbook new_resource.cookbook
    owner 'root'
    group lazy { default_recursor_run_user }
    mode '0640'
    variables(
      socket_dir: "#{recursor_socket_directory(new_resource.instance_name, new_resource.socket_dir, new_resource.virtual)}",
      variables: new_resource.variables
    )
  end
end
