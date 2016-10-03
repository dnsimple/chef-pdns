#
# Cookbook Name:: pdns
# Recipe:: _service
#
# Copyright 2014, Aetrion, LLC.
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

flavor = node['pdns']['flavor']

# Only PDNS source recursor comes with init script

template '/etc/init.d/pdns' do
  source 'pdns.init.erb'
  owner 'root'
  group 'root'
  mode 0755
  only_if { [ 'slave', 'authoritative' ].include? flavor }
  not_if {  node['pdns']['build_method'] == 'package' }
end

service_name = flavor == 'recursor' ? 'pdns-recursor' : 'pdns'

if node[:platform_family].include?('rhel')
  service service_name do
    supports status: true, restart: true, reload: true
    action [:enable, :start]
  end
else
  service service_name do
    provider Chef::Provider::Service::Init::Debian
    supports status: true, restart: true, reload: true
    action [:enable, :start]
  end
end
