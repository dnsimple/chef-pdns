#
# Cookbook Name:: pdns
# Recipe:: slave_package
#
# Copyright 2010, Opscode, Inc.
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

build_method = node['pdns']['build_method']

backends = node['pdns'][build_method]['backends'] + node['pdns']['slave']['backends']
node.set['pdns'][build_method]['backends'] = backends.uniq

include_recipe "pdns::_#{build_method}"
include_recipe 'pdns::_config'
include_recipe 'pdns::_service'

