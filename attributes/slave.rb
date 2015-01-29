#
# Cookbook Name:: pdns
# Attributes:: slave
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

default['pdns']['slave']['backends'] = %w( bind )
default['pdns']['slave']['config']['launch'] = 'bind'

default['pdns']['slave']['config']['config_dir'] = node['pdns']['config_dir']
default['pdns']['slave']['config']['setgid'] = node['pdns']['group']
default['pdns']['slave']['config']['setuid'] = node['pdns']['user']
default['pdns']['slave']['config']['version_string'] = node['pdns']['version_string']

default['pdns']['slave']['config']['master'] = false
default['pdns']['slave']['config']['slave'] = true
default['pdns']['slave']['config']['slave_cycle_interval'] = '60'
default['pdns']['slave']['config']['disable_axfr'] = true
