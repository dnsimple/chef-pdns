#
# Cookbook Name:: pdns
# Attributes:: source
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

default['pdns']['source']['path'] = '/opt'

case node['pdns']['flavor']
when 'recursor'
  default['pdns']['source']['version'] = '3.7.3'
  default['pdns']['source']['url'] = "https://downloads.powerdns.com/releases/pdns-recursor-#{node['pdns']['source']['version']}.tar.bz2"
else
  default['pdns']['source']['version'] = '3.4.7'
  default['pdns']['source']['url'] = "https://downloads.powerdns.com/releases/pdns-#{node['pdns']['source']['version']}.tar.bz2"
end
